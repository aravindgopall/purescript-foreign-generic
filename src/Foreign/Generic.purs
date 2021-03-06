module Foreign.Generic
  ( aesonSumEncoding
  , genericDecode
  , genericEncode
  , decodeJSON
  , encodeJSON
  , genericDecodeJSON
  , genericEncodeJSON
  , module Reexports
  ) where

import Prelude

import Data.Generic.Rep (class Generic, from, to)
import Foreign (F, Foreign)
import Foreign (F, Foreign, ForeignError(..)) as Reexports
import Foreign.Generic.Class (class GenericDecode, class GenericEncode, decodeOpts, encodeOpts)
import Foreign.Generic.Class (class GenericDecode, class GenericEncode, decodeOpts, encodeOpts, defaultOptions) as Reexports
import Foreign.Generic.Types (Options, SumEncoding(..)) as Reexports
import Foreign.Generic.Types (Options, SumEncoding(..))
import Foreign.JSON (parseJSON, decodeJSONWith)
import Global.Unsafe (unsafeStringify)
import Foreign.Generic.Class (class Decode, class Encode, class GenericDecode, class GenericEncode, decode, decodeOpts, encode, encodeOpts)
import Foreign.Generic.Class (class Decode, class Encode, class GenericDecode, class GenericEncode, decode, encode) as Reexports
import Foreign.JSON (decodeJSONWith, parseJSON)
import Global.Unsafe (unsafeStringify)
-- | Default decoding/encoding options:
-- |
-- | - Represent sum types as records with `tag` and `contents` fields
-- | - Unwrap single arguments
-- | - Don't unwrap single constructors
-- | - Use the constructor names as-is
-- | - Use the field names as-is

-- | Aeson unwraps records, use this sum encoding with Aeson generated json
aesonSumEncoding :: SumEncoding
aesonSumEncoding = TaggedObject
        { tagFieldName: "tag"
        , contentsFieldName: "contents"
        , constructorTagTransform: identity
        , unwrapRecords: true
        }

-- | Read a value which has a `Generic` type.
genericDecode
  :: forall a rep
   . Generic a rep
  => GenericDecode rep
  => Options
  -> Foreign
  -> F a
genericDecode opts = map to <<< decodeOpts opts

-- | Generate a `Foreign` value compatible with the `genericDecode` function.
genericEncode
  :: forall a rep
   . Generic a rep
  => GenericEncode rep
  => Options
  -> a
  -> Foreign
genericEncode opts = encodeOpts opts <<< from

-- | Decode a JSON string using a `Decode` instance.
decodeJSON
  :: forall a
   . Decode a
  => String
  -> F a
decodeJSON = decodeJSONWith decode

-- | Encode a JSON string using an `Encode` instance.
encodeJSON
  :: forall a
   . Encode a
  => a
  -> String
encodeJSON = unsafeStringify <<< encode

-- | Read a value which has a `Generic` type from a JSON String
genericDecodeJSON
  :: forall a rep
   . Generic a rep
  => GenericDecode rep
  => Options
  -> String
  -> F a
genericDecodeJSON opts = genericDecode opts <=< parseJSON

-- | Write a value which has a `Generic` type as a JSON String
genericEncodeJSON
  :: forall a rep
   . Generic a rep
  => GenericEncode rep
  => Options
  -> a
  -> String
genericEncodeJSON opts = unsafeStringify <<< genericEncode opts
