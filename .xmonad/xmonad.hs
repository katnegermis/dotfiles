import XMonad
import XMonad.Util.EZConfig
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Util.Scratchpad
import XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet as W
import qualified Data.Map as M

myWorkspaces = ["1:main-work", "2:main-web", "3:alt-work", "4:alt-web", "5:chat", "6", "7", "8", "9:slacking"]

myLogHook h = dynamicLogWithPP $ defaultPP

    -- display current workspace as darkgrey on light grey (opposite of
    -- default colors)
    { ppCurrent         = dzenColor "#303030" "#909090" . pad

    -- display other workspaces which contain windows as a brighter grey
    , ppHidden          = dzenColor "#909090" "" . pad

    -- display other workspaces with no windows as a normal grey
    , ppHiddenNoWindows = dzenColor "#606060" "" . pad

    -- display the current layout as a brighter grey
    , ppLayout          = dzenColor "#909090" "" . pad

    -- if a window on a hidden workspace needs my attention, color it so
    , ppUrgent          = dzenColor "#ff0000" "" . pad . dzenStrip

    -- shorten if it goes over 100 characters
    , ppTitle           = shorten 100

    -- no separator between workspaces
    , ppWsSep           = ""

    -- put a few spaces between each object
    , ppSep             = "  "

    -- output to the handle we were given as an argument
    , ppOutput          = hPutStrLn h
    }

leftDzen2 = "dzen2 -x '0' -y '0' -h '24' -w '960' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
rightDzen2 = "conky | dzen2 -p -x '960' -y '0' -w '960' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' "

myLayoutHook = avoidStruts (tiled ||| Mirror tiled ||| Full)
   where
     tiled = Tall 1 (3/100) (3/5)

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where
    h = 0.5
    w = 0.5
    t = 0.25
    l = 0.25

main = do
    dzenLeftBar <- spawnPipe leftDzen2
    dzenRightBar <- spawnPipe rightDzen2
    xmonad $ ewmh defaultConfig
        { borderWidth        = 2
        , terminal           = "urxvt"
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "cd8b00"
        , workspaces         = myWorkspaces
        , keys               = \c -> mykeys c `M.union` keys defaultConfig c
        , logHook             = myLogHook dzenLeftBar
        , layoutHook = myLayoutHook
        , manageHook = manageHook defaultConfig <+> manageDocks <+> manageScratchPad
        , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
        }
        `removeKeys` [ (mod1Mask, n) | n <- [xK_1 .. xK_9]]
        `removeKeys` [(mod1Mask, xK_h)]
        `removeKeys` [(mod1Mask, xK_l)]
        `removeKeys` [(mod1Mask, xK_j)]
        `removeKeys` [(mod1Mask, xK_k)]
    where
        mykeys conf@(XConfig {modMask = modm}) = M.fromList $
             [ ((modm, xK_e), spawn "firefox") -- Start firefox
             , ((modm, xK_w), spawn "gnome-calculator") -- Start calculator
             , ((modm, xK_r), spawn $ XMonad.terminal conf) -- Start terminal
             , ((modm, xK_F4), kill) -- %! Close the focused window
             , ((controlMask, xK_j), windows W.focusDown) -- %! Move focus to the next window
             , ((controlMask, xK_k), windows W.focusUp  ) -- %! Move focus to the previous window
             , ((modm .|. shiftMask, xK_r),  scratchpadSpawnAction conf)
             , ((modm .|. shiftMask, xK_n), spawn "~/.xmonad/layout_switch.sh")
             , ((modm, xK_Left), sendMessage Shrink)
             , ((modm, xK_Right), sendMessage Expand)
             ]
             ++
            [((m .|. controlMask, k), windows $ f i)
            | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F9]
            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
