import Prelude as P
import Data.Attoparsec.Text
import Data.Monoid ((<>))
import Data.Text
import Data.Text.IO as T
import Control.Applicative
import qualified Options.Applicative as OptApp

-- Command line arguments for the assembler
data CmdArgs = CmdArgs
  { sourceFilePath :: String }

-- Instruction format for internal representation
data Instruction = Instruction
                   { labelName :: String
                   , op :: String
                   , argA :: Int
                   , argB :: Int
                   , argC :: Int } deriving (Show)

-- Searches and returns label name (<label_name>:)
labelParser :: Parser String
labelParser = do
  labelName <- takeTill (== ':')
  char ':'
  string $ pack "subleq"
  return $ unpack labelName

-- Searches for `subleq' and returns an empty string
subleqParser :: Parser String
subleqParser = do
  string $ pack "subleq"
  return $ ""

-- Parser for comments starting with `;'
comment :: Parser ()
comment = do
  char ';'
  skipWhile (/= '\n')
  try $ char '\n'
  return ()

-- Take a parser and wrap it around garbage stripping
wrapStrip :: Parser a -> Parser a
wrapStrip p = do
  crap
  x <- p
  crap
  return x 
  where crap = (try $ skipMany comment) <|> (try skipSpace)

-- Parses arguments in Int from input
argumentParser :: Parser Int
argumentParser = do
  crap
  arg <- decimal
  crap
  return arg
  where crap = try $ skipSpace

-- Returns labelName if it exists
parseInstructionHeader :: Parser String
parseInstructionHeader = do
  crap
  labelName <- labelParser <|> subleqParser
  return labelName
  where crap = try $ skipSpace

-- Parses a string and returns an Instruction
instructionParser :: Parser Instruction
instructionParser = do
  labelName <- parseInstructionHeader
  argA <- argumentParser
  char ','
  argB <- argumentParser
  char ','
  argC <- argumentParser
  return $ Instruction labelName "subleq" argA argB argC

cmdArgs :: OptApp.Parser CmdArgs
cmdArgs = CmdArgs
     <$> OptApp.argument OptApp.str 
     ( OptApp.metavar "STRING"
       <> OptApp.help "Path of file to assemble" )

readSourceCode :: CmdArgs -> IO ()
readSourceCode (CmdArgs sourceFilePath) = do
  P.putStrLn "Compiled, Linked and running!"

main :: IO ()
main = (OptApp.execParser opts) >>= readSourceCode
  where
    opts = OptApp.info (OptApp.helper <*> cmdArgs)
      ( OptApp.fullDesc
     <> OptApp.progDesc "Replicate a string"
     <> OptApp.header "repstring - an example of the optparse-applicative package" )
