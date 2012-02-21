{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}

-- FlexibleInstances and MultiParamTypeClasses are necessary for the
-- LayoutClass instance declaration of Flip.

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Gnome
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad

import Control.Arrow ((***), second)
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map as M

myManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-lancher" --> doIgnore
    , isFullscreen --> doFullFloat
    ]) <+> namedScratchpadManageHook myScratchPads

-- mod1Mask = (left alt)
-- mod2Mask = (right alt)
-- mod4Mask = (super)
myModMask = mod1Mask

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myScratchPads = [ NS "pandora" spawnPandora findPandora manageMusic
                , NS "rdio" spawnRdio findRdio manageMusic
                ]
  where
    spawnPandora = "/opt/google/chrome/google-chrome '--app=http://www.pandora.com/'"
    findPandora = resource =? "www.pandora.com"
    manageMusic = customFloating $ W.RationalRect l t w h
      where
        h = 1
        w = 0.5
        t = 1 - h
        l = 1 - w

    spawnRdio = "/opt/google/chrome/google-chrome '--app=http://www.rdio.com/'"
    findRdio = resource =? "www.rdio.com"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: [(String, X ())]
myKeys =
    [
      ("M-<Backspace>", focusUrgent)
    , ("M-S-<Backspace>", clearUrgents)

    , ("M-b", sendMessage ToggleGaps)

    -- TODO: These screen-switching shortcuts conflict with browser
    -- history shortcuts.
    --, ("M-<Right>", nextScreen)
    --, ("M-<Left>",  prevScreen)
    --, ("M-S-<Right>", shiftNextScreen)
    --, ("M-S-<Left>",  shiftPrevScreen)
    , ("M-s", nextScreen)
    , ("M-S-s", swapNextScreen)
    , ("M-z", toggleWS)

    -- NamedScratchPad shortcuts
    -- TODO: These shortcuts currently override the default key for
    -- reducing the number of windows on the left side of the screen.
    , ("M-, p", namedScratchpadAction myScratchPads "pandora")
    , ("M-, r", namedScratchpadAction myScratchPads "rdio")
    ]

myWorkspaceKeys :: [((ButtonMask, KeySym), X ())]
myWorkspaceKeys =
    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    -- These are custom versions of the workspace switching keys that do
    -- not swap workspaces between screens if the workspace being
    -- switched to is on a screen that is visible, but that is not
    -- active.
    [((m .|. myModMask, k), windows $ f i)
        | (i, k) <- zip (myWorkspaces) [xK_1 .. xK_9]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- * NOTE: XMonad.Hooks.EwmhDesktops users must remove the obsolete
-- ewmhDesktopsLayout modifier from layoutHook. It no longer exists.
-- Instead use the 'ewmh' function from that module to modify your
-- defaultConfig as a whole. (See also logHook, handleEventHook, and
-- startupHook ewmh notes.)
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayouts = smartBorders $ gaps [(U, 24)] $ tiled ||| leftTiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- like tiled, but puts the master window on the right
    leftTiled = Flip tiled

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- | Flip a layout, compute its 180 degree rotated form.
newtype Flip l a = Flip (l a) deriving (Show, Read)

instance LayoutClass l a => LayoutClass (Flip l) a where
    runLayout (W.Workspace i (Flip l) ms) r = (map (second flipRect) *** fmap Flip)
                                                `fmap` runLayout (W.Workspace i l ms) (flipRect r)
                                         where screenWidth = fromIntegral $ rect_width r
                                               flipRect (Rectangle rx ry rw rh) = Rectangle (screenWidth - rx - (fromIntegral rw)) ry rw rh
    handleMessage (Flip l) = fmap (fmap Flip) . handleMessage l
    description (Flip l) = "Flip "++ description l

------------------------------------------------------------------------
-- Putting it all together
main = xmonad $ withUrgencyHookC dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }
                                 urgencyConfig { suppressWhen = Focused }
              $ gnomeConfig
              { modMask = myModMask
              , workspaces = myWorkspaces
              , manageHook = myManageHook
              , layoutHook = myLayouts
              , startupHook = setWMName "LG3D"
              } `additionalKeysP` myKeys `additionalKeys` myWorkspaceKeys
