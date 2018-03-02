import Data.Attoparsec.Text
import Data.Text
import Control.Applicative

data Instruction = Instruction
                   { labelName :: String,
                     op :: String,
                     argA :: Int,
                     argB :: Int,
                     argC :: String
                   } deriving (Show)

-- | Searches and returns label name (<label_name>:)
labelParser :: Parser String
labelParser = do
  labelName <- takeTill (== ':')
  char ':'
  string $ pack "subleq"
  return $ unpack labelName

-- | Searches and returns label name (<label_name>:)
subleqParser :: Parser String
subleqParser = do
  string $ pack "subleq"
  return $ ""

instructionParser :: Parser (String, String, String)
instructionParser = do
  labelName <- subleqParser <|> labelParser
  return (labelName, "unpack$crap", "Tjadlfkn")

