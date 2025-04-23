{-# LANGUAGE OverloadedStrings #-}
-- Build with: stack build --nix ; Run with: stack exec site
import Hakyll
import Control.Arrow ((>>>))

partialField :: Context String
partialField = functionField "partial" $ \args _ ->
    case args of
        [path] -> loadBody (fromFilePath path)
        _       -> fail "partial: expected a single argument"

main :: IO ()
main = hakyll $ do
        let assetCtx = defaultContext <> partialField
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
            route $ customRoute (takeBaseName . toFilePath >>> (<.> "html"))
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

        -- Templates
        match "templates/*" $ compile templateBodyCompiler
