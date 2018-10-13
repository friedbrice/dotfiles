#!/usr/bin/env stack
{- stack script --resolver lts-11.9 -}

import Control.Concurrent.Async (Concurrently(Concurrently, runConcurrently))
import Control.Monad (filterM, join)
import GHC.IO.Exception (ExitCode(ExitSuccess))
import System.Directory (doesDirectoryExist, getHomeDirectory, listDirectory)
import System.Process (CreateProcess(cwd), createProcess, shell, waitForProcess)

-- Concat paths without fear
(+/) :: FilePath -> FilePath -> FilePath
(+/) "" "" = ""
(+/) parent child = case (last parent, head child) of
    ('/', '/') -> parent ++ tail child
    (l, h) | l == '/' || h == '/' -> parent ++ child
    _ -> parent ++ "/" ++ child

fetchRepo :: FilePath -> CreateProcess
fetchRepo dir = cmd { cwd = Just dir } where cmd = shell "git fetch --all"

listSubdirs :: FilePath -> IO [FilePath]
listSubdirs parentdir = do
    files <- listDirectory parentdir
    let paths = fmap (parentdir +/) files
    filterM (doesDirectoryExist . (+/ ".git")) paths

concurrentlyRetryForever :: [CreateProcess] -> IO ()
concurrentlyRetryForever procs = do
    handles <- runConcurrently . traverse (Concurrently . createProcess) $ procs
    codes <- traverse (waitForProcess . \(_,_,_,h) -> h) $ handles
    let failures = [ p | (p, c) <- zip procs codes, c /= ExitSuccess ]
    if null failures then pure () else concurrentlyRetryForever failures

main :: IO ()
main = do
    home <- getHomeDirectory
    let fullPaths = fmap (home +/) dirs
    repos <- traverse listSubdirs fullPaths
    concurrentlyRetryForever (fmap fetchRepo (join repos))

-- relative to user home directory
dirs :: [FilePath]
dirs = ["friedbrice", "lumihq", "abs/aur"]
