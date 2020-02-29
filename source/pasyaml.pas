(******************************************************************************)
(*                                 libPasYAML                                 *)
(*                object pascal wrapper around libyaml library                *)
(*                       https://github.com/yaml/libyaml                      *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/libpasyaml                  ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the GNU General Public License as published by the Free *)
(* Software Foundation; either version 3 of the License.                      *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for *)
(* more details.                                                              *)
(*                                                                            *)
(* A copy  of the  GNU General Public License is available  on the World Wide *)
(* Web at <http://www.gnu.org/copyleft/gpl.html>. You  can also obtain  it by *)
(* writing to the Free Software Foundation, Inc., 51  Franklin Street - Fifth *)
(* Floor, Boston, MA 02110-1335, USA.                                         *)
(*                                                                            *)
(******************************************************************************)

unit pasyaml;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  Classes, SysUtils, libpasyaml;

type
  { TYamlConfig }
  { Configuration file }
  TYamlConfig = class
  public
    type
      { Document encoding }
      TEncoding = (
        { Let the parser choose the encoding. }
        ENCODING_DEFAULT = Longint(YAML_ANY_ENCODING),
        { The default UTF-8 encoding. }
        ENCODING_UTF8    = Longint(YAML_UTF8_ENCODING),
        { The UTF-16-LE encoding with BOM. }
        ENCODING_UTF16LE = Longint(YAML_UTF16LE_ENCODING),
        { The UTF-16-BE encoding with BOM. }
        ENCODING_UTF16BE = Longint(YAML_UTF16BE_ENCODING)
      );

      { Yaml mapping style }
      TMapStyle = (
        { Let the emitter choose the style. }
        STYLE_ANY   = Longint(YAML_ANY_MAPPING_STYLE),
        { The block mapping style. }
        STYLE_BLOCK = Longint(YAML_BLOCK_MAPPING_STYLE),
        { The flow mapping style. }
        STYLE_FLOW  = Longint(YAML_FLOW_MAPPING_STYLE)
      );

      { Yaml sequence style }
      TSequenceStyle = (
        { Let the emitter choose the style. }
        STYLE_ANY = Longint(YAML_ANY_SEQUENCE_STYLE),
        { The block sequence style. }
        STYLE_BLOCK = Longint(YAML_BLOCK_SEQUENCE_STYLE),
        { The flow sequence style. }
        STYLE_FLOW = Longint(YAML_FLOW_SEQUENCE_STYLE)
      );

      { TOptionWriter }
      { Writer for configuration option }
      TOptionWriter = class

      end;

      { TOptionReader }
      { Reader for configuration option }
      TOptionReader = class

      end;
  private
    FEmitter : yaml_emitter_t;
    FEvent : yaml_event_t;
  private
    function _CreateMap (Style : TMapStyle) : TOptionWriter;{$IFDEF DEBUG}
      inline;{$ENDIF}
    function _CreateSequence (Style : TSequenceStyle) : TOptionWriter;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  public
    constructor Create (Encoding : TEncoding = ENCODING_UTF8);
    destructor Destroy; override;

    { Create new map section }
    property CreateMap [Style : TMapStyle] : TOptionWriter read
      _CreateMap;

    { Create new sequence section }
    property CreateSequence [Style : TSequenceStyle] : TOptionWriter read
      _CreateSequence;
  end;

implementation

{ TYamlConfig }

constructor TYamlConfig.Create (Encoding : TEncoding);
begin
  yaml_emitter_initialize(@FEmitter);
  yaml_stream_start_event_initialize(@FEvent, yaml_encoding_t(Encoding));
  yaml_document_start_event_initialize(@FEvent, nil, nil, nil, 0);
end;

destructor TYamlConfig.Destroy;
begin
  yaml_stream_end_event_initialize(@FEvent);
  yaml_emitter_delete(@FEmitter);
  inherited Destroy;
end;

end.

