{-# LANGUAGE OverloadedStrings #-}
-- Build with: stack build --nix ; Run with: stack exec site
import Hakyll

main :: IO ()
main = hakyll $ do
    let assetCtx = field "cssPath" (\_ -> do
                                mcss <- getRoute "static/css/main.css"
                                return (maybe "/static/css/main.css" id mcss))
                 <> field "jsPath" (\_ -> do
                                mjs <- getRoute "static/js/bundle.js"
                                return (maybe "/static/js/bundle.js" id mjs))
                 <> defaultContext
    -- Copy static files
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "static/css/*" $ do
        route   fingerprintRoute
        compile compressCssCompiler

    match "static/js/*" $ do
        route   fingerprintRoute
        compile copyFileCompiler

    -- Build pages from Markdown with YAML headers
    match (fromList ["about.md", "contact.md"]) $ do
        route   $ setExtension "html"
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
where
    postCtx = dateField "date" "%B %e, %Y" <> assetCtx
