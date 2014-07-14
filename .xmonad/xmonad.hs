import Control.Monad
import System.IO
import System.Exit

import XMonad
import XMonad.Actions.SpawnOn (spawnOn)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Util.Run ( spawnPipe )
import XMonad.Util.EZConfig ( additionalKeysP, removeKeysP )

myModMask :: KeyMask
myModMask = mod4Mask

-- | Terminal
myTerminal = "urxvt"

-- | Workspaces
myWorkSpaces = ["term", "web", "code", "file", "media", "irc", "doc"] ++ map show [8..9]

-- | Custom Manage Hooks
-- | Defines the workspace an application has to go
myManageHook = composeAll . concat $
               [
                 -- HACK
                 [ title     =? "i-urxvt" --> viewShift "term" ]
               , [ className =? b --> viewShift "web"       | b <- webApplications ]
               , [ className =? e --> viewShift "code"      | e <- editors ]
               , [ title     =? f --> viewShift "file"      | f <- fileManagers ]
               , [ className =? f --> viewShift "file"      | f <- fileManagers ]
               , [ className =? m --> doF (W.shift "media") | m <- mediaApplications ]
               , [ title     =? c --> doF (W.shift "irc")   | c <- chatApplications ]
               , [ className =? d --> viewShift "doc"       | d <- docApplications ]
               ]
    where
      viewShift         = doF . liftM2 (.) W.greedyView W.shift
      webApplications   = [ "Firefox", "Google-chrome-stable" ]
      fileManagers      = [ "ranger", "Thunar" ]
      chatApplications  = [ "weechat", "irssi", "XChat" ]
      editors           = [ "Emacs", "Subl" ]
      docApplications   = [ "Evince", "LibreOffice" ]
      mediaApplications = [ "Vlc", "cmus" ]

myStartupHook :: X ()
myStartupHook = do
  spawn browser
  spawn editor
  spawn fileManager
  spawn irc
  -- Hack to spawn Terminal on WS term
  spawn "urxvt -T i-urxvt"
  where
    browser     = "google-chrome-stable"
    editor      = "emacs"
    irc         = inTerminal "weechat"
    fileManager = inTerminal "ranger"
    -- Terminal applications
    inTerminal :: String -> String
    inTerminal x = myTerminal ++ " -T " ++ x ++ " -e " ++ x

keysToRemove :: [String]
keysToRemove = [ "M-p"   -- Remove default dmenu keybinding
               , "M-S-q" -- Exit X
               , "M-S-c" -- Kill Windows
               , "M-S-<Return>" -- Start Terminal
               ]

keysToAdd :: [(String, X())]
keysToAdd = [ ("M-d", spawn "dmenu_run")
            , ("M-S-q", kill)
            , ("M-S-e", io (exitWith ExitSuccess))
            , ("M-<Tab>", spawn $ myTerminal)
            , ("M1-<Tab>", windows W.focusDown)
            , ("<XF86AudioRaiseVolume>", spawn "/usr/bin/pactl set-sink-volume 0 -- '+5%'")
            , ("<XF86AudioLowerVolume>", spawn "/usr/bin/pactl set-sink-volume 0 -- '-5%'")
            , ("<XF86AudioMute>", spawn "/usr/bin/pactl set-sink-mute 0 toggle")
            , ("<XF86MonBrightnessUp>",  spawn "/usr/bin/xbacklight -inc 10")
            , ("<XF86MonBrightnessDown>", spawn "/usr/bin/xbacklight -dec 5")
            , ("<XF86TouchpadToggle>", spawn "/usr/local/bin/touchpadToggle")
            ]

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
       { -- | Simple Stuff
         modMask = myModMask  -- Rebind Mod to Windows Key
       , terminal = myTerminal
       , workspaces = myWorkSpaces

       -- | Hooks, layouts
       , manageHook = manageDocks <+> myManageHook
                      <+> manageHook defaultConfig
       , layoutHook = avoidStruts $ layoutHook defaultConfig
       , logHook = dynamicLogWithPP xmobarPP
                   { ppOutput = hPutStrLn xmproc
                   , ppTitle = xmobarColor "green" "" . shorten 50
                   }
       , startupHook = myStartupHook
       }
       `removeKeysP` keysToRemove
       `additionalKeysP` keysToAdd
