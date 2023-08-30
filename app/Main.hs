{-# OPTIONS -Wall #-}
module Main where

import Data.List
import GHC.Float
import Foreign.Marshal.Utils

import Raylib.Core (clearBackground, setConfigFlags, isKeyPressed, setTraceLogLevel)
import Raylib.Core.Text (drawText)
import Raylib.Util (drawing, whileWindowOpen, withWindow)
import Raylib.Util.Colors (white)
import Raylib.Types (ConfigFlag(WindowTransparent), Color(Color), KeyboardKey(KeySpace), TraceLogLevel(LogNone))
import Raylib.Core.Textures (drawTexture, loadImage, loadTextureFromImage)

type User = (String, Int)

getSave :: String -> IO User
getSave fileName = do
    saveData <- readFile fileName 
    let datlst = lines saveData
    return (datlst !! 0, read (datlst !! 1))

defWidth  = 540
defHeight = 320
halfY = defHeight `div` 2

main :: IO ()
main = do
    saveData <- getSave "LinuxClicker_savefile.txt"
    let tuxesLoaded = snd saveData
    setConfigFlags [WindowTransparent]
    setTraceLogLevel LogNone
    withWindow
        defWidth
        defHeight
        "Linux Clicker v0.1"
        60
        ( \window -> do
            tuxtext <- loadImage "tuxImg.png" >>= (`loadTextureFromImage` window)
            ressss <- whileWindowOpen
                    ( \tuxes -> do
                        drawing
                            ( do
                                clearBackground $ Color 0x00 0x00 0x00 0x00
                                drawTexture tuxtext 10 10 white
                                drawText ("Login: " <> fst saveData) 300 ((halfY)-20) 20 white
                                drawText ("Tuxes: " <> show tuxes) 300 (halfY+20) 20 white
                            )
                        spacePressed <- isKeyPressed KeySpace
                        return (tuxes + fromBool spacePressed)
                    )
                    tuxesLoaded
            writeFile "LinuxClicker_savefile.txt" $ (fst saveData) <> "\n" <> show ressss
        )
