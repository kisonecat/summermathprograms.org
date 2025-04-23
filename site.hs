{-# LANGUAGE OverloadedStrings #-}
-- Build with: stack build --nix ; Run with: stack exec site
import Hakyll
import Control.Arrow ((>>>))
import Control.Monad (forM)
import System.FilePath (takeDirectory)
import Data.Aeson (encode)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Map as M

main :: IO ()
main = hakyll $ do
        let assetCtx = defaultContext
            postCtx = dateField "date" "%B %e, %Y" <> assetCtx

        -- Copy static files
        match "images/*" $ do
            route   idRoute
            compile copyFileCompiler

        match "static/css/*" $ do
            route   idRoute
            compile compressCssCompiler

        match "static/js/*" $ do
            route   idRoute
            compile copyFileCompiler

        -- Build pages from Markdown with YAML headers
        match "pages/*.md" $ do
            route $ gsubRoute "pages/" (const "") `composeRoutes` setExtension "html"
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" assetCtx
                >>= relativizeUrls

        -- Programs pages: convert programs/*/index.md to programs/<directory>.html
        match "programs/*/index.md" $ do
            route $ customRoute (\identifier ->
                let p = toFilePath identifier in (takeDirectory p) ++ ".html")
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" assetCtx
                >>= relativizeUrls

        -- Posts
        match "posts/*" $ do
            route $ setExtension "html"
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/post.html" postCtx
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls

        create ["programs.json"] $ do
          route idRoute
          compile $ do
            -- load each programs/*/index.md as an Item
            items     <- (loadAll "programs/*/index.md" :: Compiler [Item String])
            -- for each one, look up its front‐matter
            metadata  <- forM items $ \item ->
              getMetadata (itemIdentifier item)
            -- metadata :: [M.Map String String]
            let json = BL.unpack (encode metadata)
            makeItem json

        -- Templates
        match "templates/*" $ compile templateBodyCompiler
