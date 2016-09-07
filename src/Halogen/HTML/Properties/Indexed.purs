-- | A closed signature of type-indexed (refined) HTML properties; these can be
-- | used to ensure correctness by construction, and then erased into the standard
-- | unrefined versions.
module Halogen.HTML.Properties.Indexed
  ( IProp(..)
  , I()

  , ButtonType(..)
  , InputType(..)
  , MediaType(..)
  , MenuType(..)
  , MenuitemType(..)
  , OrderedListType(..)
  , NumeralType(..)
  , CaseType(..)

  , key

  , alt
  , charset
  , class_, classes
  , cols
  , rows
  , colSpan
  , rowSpan
  , for
  , height
  , width
  , href
  , id_
  , name
  , rel
  , src
  , target
  , title

  -- replacements for `type`
  , buttonType
  , inputType
  , mediaType
  , menuType
  , menuitemType
  , olType

  , value
  , disabled
  , enabled
  , required
  , readonly
  , spellcheck
  , checked
  , selected
  , placeholder
  , autocomplete
  , autofocus
  , multiple

  , draggable
  , tabIndex

  , ref

  , GlobalAttributes()
  , GlobalEvents()
  , MouseEvents()
  , KeyEvents()
  , FocusEvents()
  , TransitionEvents()
  , InteractiveEvents()
  , GlobalProperties()
  ) where

import Prelude

import Data.Array as A
import Data.Foldable (intercalate)
import Data.Maybe (Maybe())
import Data.Tuple (Tuple(..))

import Unsafe.Coerce (unsafeCoerce)

import DOM.HTML.Types (HTMLElement())

import Halogen.HTML.Core (Prop(), ClassName())
import Halogen.HTML.Properties as P

-- | The phantom row `r` can be thought of as a context which is synthesized in the
-- | course of constructing a refined HTML expression.
newtype IProp (r :: # *) i = IProp (Prop i)

-- | A dummy type to use in the phantom row.
data I

refine :: forall a r i. (a -> Prop i) -> a -> IProp r i
refine = unsafeCoerce

key :: forall r i. String -> IProp (key :: I | r) i
key = refine P.key

alt :: forall r i. String -> IProp (alt :: I | r) i
alt = refine P.alt

charset :: forall r i. String -> IProp (charset :: I | r) i
charset = refine P.charset

class_ :: forall r i. ClassName -> IProp (class :: I | r) i
class_ = refine P.class_

classes :: forall r i. Array ClassName -> IProp (class :: I | r) i
classes = refine P.classes

cols :: forall r i. Int -> IProp (cols :: I | r) i
cols = refine P.cols

rows :: forall r i. Int -> IProp (rows :: I | r) i
rows = refine P.rows

colSpan :: forall r i. Int -> IProp (colSpan :: I | r) i
colSpan = refine P.colSpan

rowSpan :: forall r i. Int -> IProp (rowSpan :: I | r) i
rowSpan = refine P.rowSpan

for :: forall r i. String -> IProp (for :: I | r) i
for = refine P.for

height :: forall r i. Int -> IProp (height :: I | r) i
height = refine P.height

width :: forall r i. Int -> IProp (width :: I | r) i
width = refine P.width

href :: forall r i. String -> IProp (href :: I | r) i
href = refine P.href

id_ :: forall r i. String -> IProp (id :: I | r) i
id_ = refine P.id_

name :: forall r i. String -> IProp (name :: I | r) i
name = refine P.name

rel :: forall r i. String -> IProp (rel :: I | r) i
rel = refine P.rel

src :: forall r i. String -> IProp (src :: I | r) i
src = refine P.src

target :: forall r i. String -> IProp (target :: I | r) i
target = refine P.target

title :: forall r i. String -> IProp (title :: I | r) i
title = refine P.title

data InputType
  = InputButton
  | InputCheckbox
  | InputColor
  | InputDate
  | InputDatetime
  | InputDatetimeLocal
  | InputEmail
  | InputFile
  | InputHidden
  | InputImage
  | InputMonth
  | InputNumber
  | InputPassword
  | InputRadio
  | InputRange
  | InputReset
  | InputSearch
  | InputSubmit
  | InputTel
  | InputText
  | InputTime
  | InputUrl
  | InputWeek

renderInputType :: InputType -> String
renderInputType ty =
  case ty of
    InputButton -> "button"
    InputCheckbox -> "checkbox"
    InputColor -> "color"
    InputDate -> "date"
    InputDatetime -> "datetime"
    InputDatetimeLocal -> "datetime-local"
    InputEmail -> "email"
    InputFile -> "file"
    InputHidden -> "hidden"
    InputImage -> "image"
    InputMonth -> "month"
    InputNumber -> "number"
    InputPassword -> "password"
    InputRadio -> "radio"
    InputRange -> "range"
    InputReset -> "reset"
    InputSearch -> "search"
    InputSubmit -> "submit"
    InputTel -> "tel"
    InputText -> "text"
    InputTime -> "time"
    InputUrl -> "url"
    InputWeek -> "week"

inputType :: forall r i. InputType -> IProp (inputType :: I | r) i
inputType = refine P.type_ <<< renderInputType

data MenuType
  = MenuList
  | MenuContext
  | MenuToolbar

renderMenuType :: MenuType -> String
renderMenuType ty =
  case ty of
    MenuList -> "list"
    MenuContext -> "context"
    MenuToolbar -> "toolbar"

menuType :: forall r i. MenuType -> IProp (menuType :: I | r) i
menuType = refine P.type_ <<< renderMenuType

data MenuitemType
  = MenuitemCommand
  | MenuitemCheckbox
  | MenuitemRadio

renderMenuitemType :: MenuitemType -> String
renderMenuitemType ty =
  case ty of
    MenuitemCommand -> "command"
    MenuitemCheckbox -> "checkbox"
    MenuitemRadio -> "radio"

menuitemType :: forall r i. MenuitemType -> IProp (menuitemType :: I | r) i
menuitemType= refine P.type_ <<< renderMenuitemType

type MediaType =
  { type :: String
  , subtype :: String
  , parameters :: Array (Tuple String String)
  }

renderMediaType :: MediaType -> String
renderMediaType ty = ty.type <> "/" <> ty.subtype <> renderParameters ty.parameters
  where
    renderParameters :: Array (Tuple String String) -> String
    renderParameters ps
      | A.length ps == 0 = ""
      | otherwise = ";" <> intercalate ";" (renderParameter <$> ps)

    renderParameter :: Tuple String String -> String
    renderParameter (Tuple k v) = k <> "=" <> v

mediaType :: forall r i. MediaType -> IProp (mediaType :: I | r) i
mediaType = refine P.type_ <<< renderMediaType

data ButtonType
  = ButtonButton
  | ButtonSubmit
  | ButtonReset

renderButtonType :: ButtonType -> String
renderButtonType ty =
  case ty of
    ButtonButton -> "button"
    ButtonSubmit -> "submit"
    ButtonReset -> "reset"

buttonType :: forall r i. ButtonType -> IProp (buttonType :: I | r) i
buttonType = refine P.type_ <<< renderButtonType

data CaseType
  = Uppercase
  | Lowercase

data NumeralType
  = NumeralDecimal
  | NumeralRoman CaseType

data OrderedListType
  = OrderedListNumeric NumeralType
  | OrderedListAlphabetic CaseType

renderOrderedListType :: OrderedListType -> String
renderOrderedListType ty =
  case ty of
    OrderedListNumeric nty ->
      case nty of
        NumeralDecimal -> "1"
        NumeralRoman cty ->
          case cty of
            Lowercase -> "i"
            Uppercase -> "I"
    OrderedListAlphabetic cty ->
      case cty of
        Lowercase -> "a"
        Uppercase -> "A"

olType :: forall r i. OrderedListType -> IProp (olType :: I | r) i
olType = refine P.type_ <<< renderOrderedListType

value :: forall r i. String -> IProp (value :: I | r) i
value = refine P.value

disabled :: forall r i. Boolean -> IProp (disabled :: I | r) i
disabled = refine P.disabled

required :: forall r i. Boolean -> IProp (required :: I | r) i
required = refine P.required

readonly :: forall r i. Boolean -> IProp (readonly :: I | r) i
readonly = refine P.readonly

spellcheck :: forall r i. Boolean -> IProp (spellcheck :: I | r) i
spellcheck = refine P.spellcheck

enabled :: forall r i. Boolean -> IProp (disabled :: I | r) i
enabled = disabled <<< not

checked :: forall r i. Boolean -> IProp (checked :: I | r) i
checked = refine P.checked

selected :: forall r i. Boolean -> IProp (selected :: I | r) i
selected = refine P.selected

placeholder :: forall r i. String -> IProp (placeholder :: I | r) i
placeholder = refine P.placeholder

autocomplete :: forall r i. Boolean -> IProp (autocomplete :: I | r) i
autocomplete = refine P.autocomplete

autofocus :: forall r i. Boolean -> IProp (autofocus :: I | r) i
autofocus = refine P.autofocus

multiple :: forall r i. Boolean -> IProp (multiple :: I | r) i
multiple = refine P.multiple

draggable :: forall r i. Boolean -> IProp (draggable :: I | r) i
draggable = refine P.draggable

tabIndex :: forall r i. Int -> IProp (tabIndex :: I | r) i
tabIndex = refine P.tabIndex

ref :: forall r i. (Maybe HTMLElement -> i) -> IProp (ref :: I | r) i
ref = refine P.ref

type GlobalAttributes r =
  ( id :: I
  , name :: I
  , title :: I
  , class :: I
  , style :: I
  , spellcheck :: I
  , key :: I
  , draggable :: I
  , tabIndex :: I
  , ref :: I
  | r
  )

type GlobalEvents r =
  ( onContextMenu :: I
  | r
  )

type MouseEvents r =
  ( onDoubleClick :: I
  , onClick :: I
  , onMouseDown :: I
  , onMouseEnter :: I
  , onMouseLeave :: I
  , onMouseMove :: I
  , onMouseOver :: I
  , onMouseOut :: I
  , onMouseUp :: I
  | r
  )

type KeyEvents r =
  ( onKeyDown :: I
  , onKeyUp :: I
  , onKeyPress :: I
  | r
  )

type TransitionEvents r =
  ( onTransitionEnd :: I
  | r
  )

type FocusEvents r =
  ( onBlur :: I
  , onFocus :: I
  , onFocusIn :: I
  , onFocusOut :: I
  | r
  )

type InteractiveEvents r = FocusEvents (TransitionEvents (KeyEvents (MouseEvents r)))
type GlobalProperties r = GlobalAttributes (GlobalEvents r)
