{-# LANGUAGE OverloadedStrings #-}
-- Build with: stack build --nix ; Run with: stack exec site
import Hakyll
-- import Hakyll.Contrib.Routes.CleanRoute (cleanRoute)
import Control.Arrow ((>>>))
import Control.Monad (forM)
import System.FilePath (takeDirectory, dropExtension, takeFileName)
import Data.List (stripPrefix)
import Data.Aeson (encode)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Map as M
import Control.Monad.Error.Class (catchError)
import Data.Time (getCurrentTime)
import Data.Time.Calendar (toGregorian)
import Data.Time.Clock (utctDay)
import Text.Pandoc.Definition (Pandoc(..), Block(..))

cleanRoute :: Routes
cleanRoute = customRoute $ \ident ->
  let fp  = toFilePath ident
      rel = case stripPrefix "pages/" fp of
              Just r  -> r
              Nothing -> fp
      dir  = takeDirectory rel
      file = dropExtension (takeFileName rel)
  in if file == "index"
     then if null dir then "index.html" else dir ++ "/index.html"
     else if null dir then file ++ "/index.html"
          else dir ++ "/" ++ file ++ "/index.html"

theYear :: Context String
theYear = field "theYear" $ \_ -> do
    time <- unsafeCompiler getCurrentTime
    let (year, _, _) = toGregorian (utctDay time)
    return (show year)

addProseDiv :: Pandoc -> Pandoc
addProseDiv (Pandoc meta blocks) = Pandoc meta [Div ("", ["prose", "prose-lg", "mx-auto"], []) blocks]

main :: IO ()
main = hakyll $ do
        let assetCtx = defaultContext <> theYear
            postCtx = dateField "date" "%B %e, %Y" <> assetCtx
            programCardCtx = field "excerpt" (\item -> do
                                  let body = itemBody item
                                  return (if length body > 150 then take 150 body ++ "..." else body))
                               <> assetCtx

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
            route cleanRoute
            compile $ pandocCompilerWithTransform defaultHakyllReaderOptions defaultHakyllWriterOptions addProseDiv
                >>= loadAndApplyTemplate "templates/default.html" assetCtx
                >>= relativizeUrls

        match "pages/for/*.md" $ do
            route cleanRoute
            compile $ pandocCompilerWithTransform defaultHakyllReaderOptions defaultHakyllWriterOptions addProseDiv
                >>= loadAndApplyTemplate "templates/default.html" assetCtx
                >>= relativizeUrls

        -- Programs pages: convert programs/*/index.md to programs/<directory>.html
        match "programs/*/index.md" $ do
            route $ customRoute (\identifier ->
                let fp = toFilePath identifier
                    dir = takeDirectory fp
                in dir ++ "/index.html")
            compile $ pandocCompilerWithTransform defaultHakyllReaderOptions defaultHakyllWriterOptions addProseDiv
                >>= loadAndApplyTemplate "templates/default.html" assetCtx
                >>= relativizeUrls

        -- Generate program card partials for each program markdown file
        match "programs/*/index.md" $ version "card" $ do
            route $ customRoute (\ident ->
                let fp = toFilePath ident
                    name = dropExtension (takeFileName fp)
                in "partials/" ++ name ++ ".html")
            compile $ pandocCompilerWithTransform defaultHakyllReaderOptions defaultHakyllWriterOptions addProseDiv
                >>= loadAndApplyTemplate "templates/program_partial.html" programCardCtx
                >>= relativizeUrls

        -- Posts
        match "posts/*" $ do
            route cleanRoute
            compile $ pandocCompilerWithTransform defaultHakyllReaderOptions defaultHakyllWriterOptions addProseDiv
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
              getMetadata (itemIdentifier item) `catchError` (\_ -> return mempty)
            -- metadata :: [M.Map String String]
            let json = BL.unpack (encode metadata)
            makeItem json

        -- Templates
        match "templates/*" $ compile templateBodyCompiler
