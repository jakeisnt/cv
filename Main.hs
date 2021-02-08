#!/usr/bin/env runhaskell
{-# LANGUAGE OverloadedStrings #-} -- use strings for Turtle commands
module Parser where
import           Data.Aeson
import qualified Data.ByteString.Lazy          as B
import           Data.Time
import           Data.Time.Calendar
import           Data.Time.Format
import           Numeric                        ( showHex )
import           System.Environment
import           System.IO
import           System.Locale
import qualified Turtle                        as T


-- Aeson notes
-- - use Data.ByteString.Lazy.readFile to read files, not Prelude's
-- -  cna convert to and from bytestring, but this gets worse performance

-- type to or from JSON should be instance of FromJSON and ToJSON
-- fromJSON is Read - decode, toJSON is Show - encode

-- Aeson has trouble decoding: need to give it a type hint (i.e. decode "[1, 2, 3]")
-- eitherDecode presents the exact error run into from not being able to make the encoding: Either String <Type>

main :: IO ()
main = do
  putStrLn "done"
  -- [file] <- getArgs
  -- bs     <- B.readFile file
  -- putStrLn
  --   $ (case (decode bs) of
  --       Just a  -> show a
  --       Nothing -> "Sorry nothing here"
  --     )
  -- action <- B.writeFile "tmp.tmp" bs
  -- putStrLn "done"
  -- T.echo "pee pee poo poo"

data Profile = Profile
  { network    :: String
  , username   :: String
  , profileURL :: String
  }

-- A Link is a reference to a website with an optional title
data Link = Link
  { linkTitle :: Maybe String
  , linkURL   :: String
  }

-- A Course is a class taken from an academic institution
data Course = Course
  { crn        :: String
  , courseName :: String
  }

-- An Education is an educational experience with an institution
data Education = Education
  { institution      :: String
  , field            :: String
  , level            :: String
  , edStartDate      :: Day
  , edEndDate        :: Maybe Day
  , gpa              :: String
  , extracirriculars :: [String]
  , courses          :: [Course]
  }

-- A Description is the desctiption of a resume item
data Description = Summary String | Highlights [String]

-- A WorkExperience is a term of employment
data WorkExperience = WorkExperience
  { company        :: String
  , position       :: String
  , companyWebsite :: Maybe String
  , workStartDate  :: Day
  , workEndDate    :: Maybe Day
  , summary        :: Description
  }

-- A Project is a project on the resume
data Project = OpenProject {
    openTitle :: String,
    subtitle :: String,
    link :: Maybe String,
    description :: Description
  } | ClosedProject {
    closedTitle :: String,
    subtitle :: String,
    description :: Description
  }

-- A Resume is a complete set of Resume data
data Resume = Resume
  { personName :: String
  , email      :: String
  , phone      :: String
  , website    :: String
  , profiles   :: [Profile]
  , links      :: [Link]
  , education  :: [Education]
  , work       :: [WorkExperience]
  , projects   :: [Project]
  }

-- Parses the ByteString read in to a Resume object
parseResume :: ByteString -> Resume
parseResume s = error "bad"


-- Makes the resume and compiles on disk.
-- returns true on success and false otherwise.
-- makeResume :: Resume -> Bool
