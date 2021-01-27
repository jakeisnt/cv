-- | 

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

main :: IO ()
main = do
  [file] <- getArgs
  bs     <- B.readFile file
  action <- B.writeFile "tmp.tmp" bs
  putStrLn "done"

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
