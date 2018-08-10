#!/usr/bin/env stack
{-  stack script --resolver lts-11.9 -}

import Control.Concurrent.Async (Concurrently(Concurrently, runConcurrently))
import Control.Monad (filterM, join)
import GHC.IO.Exception (ExitCode(ExitSuccess))
import System.Directory (doesDirectoryExist, getHomeDirectory, listDirectory)
import System.Process (CreateProcess(cwd), createProcess, shell, waitForProcess)

fetchRepo :: FilePath -> CreateProcess
fetchRepo dir = cmd { cwd = Just dir } where cmd = shell "git fetch --all"

listSubdirs :: FilePath -> IO [FilePath]
listSubdirs parentdir = do
    files <- listDirectory parentdir
    let paths = fmap (parentdir ++) files
    filterM doesDirectoryExist paths

concurrentlyRetryForever :: [CreateProcess] -> IO ()
concurrentlyRetryForever procs = do
    handles <- runConcurrently . traverse (Concurrently . createProcess) $ procs
    codes <- traverse (waitForProcess . \(_,_,_,h) -> h) $ handles
    let failures = [ proc | (proc, code) <- zip procs codes, code /= ExitSuccess ]
    if null failures then pure () else concurrentlyRetryForever failures

main :: IO ()
main = do
    home <- getHomeDirectory
    let fullPaths = fmap (\d -> home ++ "/" ++ d) dirs
    repos <- traverse listSubdirs fullPaths
    concurrentlyRetryForever (fmap fetchRepo (join repos))

-- relative to user home directory
dirs :: [FilePath]
dirs = ["friedbrice", "lumihq"]
