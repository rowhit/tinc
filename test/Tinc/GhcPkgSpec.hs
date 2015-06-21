{-# LANGUAGE CPP #-}
module Tinc.GhcPkgSpec (spec) where

import           Helper

import           Tinc.GhcPkg
import           Tinc.Cache
import           Package

globalPackages :: [String]
globalPackages = [
    "array"
  , "base"
  , "binary"
  , "bin-package-db"
  , "bytestring"
  , "Cabal"
  , "containers"
  , "deepseq"
  , "directory"
  , "filepath"
  , "ghc"
  , "ghc-prim"
  , "hoopl"
  , "hpc"
  , "integer-gmp"
  , "pretty"
  , "process"
  , "rts"
  , "template-haskell"
  , "time"
  , "unix"
  , "haskeline"
  , "terminfo"
  , "transformers"
  , "xhtml"
#if __GLASGOW_HASKELL__ < 710
  , "haskell2010"
  , "haskell98"
  , "old-locale"
  , "old-time"
#endif
  ]

spec :: Spec
spec = do
  describe "listGlobalPackages" $ do
    it "lists packages from global package database" $ do
      packages <- listGlobalPackages
      map packageName packages `shouldMatchList` globalPackages

  beforeAll_ ensureCache $ do
    describe "listPackages" $ do
      it "lists packages from specified package database" $ do
        packageDb <- findPackageDb getoptGenericsSandbox
        packages <- listPackages [packageDb]
        packages `shouldMatchList` getoptGenericsPackages

      it "accepts multiple package databases" $ do
        packageDbs <- mapM findPackageDb [getoptGenericsSandbox, setenvSandbox]
        packages <- listPackages packageDbs
        packages `shouldMatchList` (setenv : getoptGenericsPackages)