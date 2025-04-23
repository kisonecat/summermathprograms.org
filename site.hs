{-# LANGUAGE OverloadedStrings #-}
-- Build with: stack build --nix ; Run with: stack exec site
import Hakyll

main :: IO ()
main = hakyll $ do
    let cacheBustCtx = constField "cacheBust" "v=2684b4a" <> defaultContext
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
    match (fromList ["about.md", "contact.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" cacheBustCtx
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
    postCtx = dateField "date" "%B %e, %Y" <> cacheBustCtx
