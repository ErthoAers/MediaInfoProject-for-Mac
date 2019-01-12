/*  Copyright (c) MediaArea.net SARL. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license that can
 *  be found in the License.html file in the root of the source tree.
 */

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// Public DLL interface implementation
// Wrapper for MediaInfo Library
// Please see MediaInfo.h for help
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

#ifndef MediaInfoDLL_StaticH
#define MediaInfoDLL_StaticH

//***************************************************************************
// Platforms (from libzen)
//***************************************************************************

/*---------------------------------------------------------------------------*/
/*MacOS X*/
#ifndef MACOSX
    #define MACOSX
#endif
#ifndef _MACOSX
    #define _MACOSX
#endif
#ifndef __MACOSX__
    #define __MACOSX__ 1
#endif

/*-------------------------------------------------------------------------*/
#undef MEDIAINFO_EXP

#if __GNUC__ >= 4
    #define MEDIAINFO_EXP __attribute__ ((visibility("default")))
#else
    #define MEDIAINFO_EXP
#endif

#if !defined(__WINDOWS__)
    #define __stdcall //Supported only on windows
#endif //!defined(__WINDOWS__)

/*-------------------------------------------------------------------------*/
#include <limits.h>

/*-------------------------------------------------------------------------*/
/*8-bit int                                                                */
#if UCHAR_MAX==0xff
    #undef  MAXTYPE_INT
    #define MAXTYPE_INT 8
    typedef unsigned char       MediaInfo_int8u;
#else
    #pragma message This machine has no 8-bit integertype?
#endif
/*-------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------*/
/*64-bit int                                                               */
#undef  MAXTYPE_INT
#define MAXTYPE_INT 64
typedef unsigned long long  MediaInfo_int64u;
/*-------------------------------------------------------------------------*/

/** @brief Kinds of Stream */
typedef enum MediaInfo_stream_t
{
    MediaInfo_Stream_General,
    MediaInfo_Stream_Video,
    MediaInfo_Stream_Audio,
    MediaInfo_Stream_Text,
    MediaInfo_Stream_Other,
    MediaInfo_Stream_Image,
    MediaInfo_Stream_Menu,
    MediaInfo_Stream_Max
} MediaInfo_stream_C;

/** @brief Kinds of Info */
typedef enum MediaInfo_info_t
{
    MediaInfo_Info_Name,
    MediaInfo_Info_Text,
    MediaInfo_Info_Measure,
    MediaInfo_Info_Options,
    MediaInfo_Info_Name_Text,
    MediaInfo_Info_Measure_Text,
    MediaInfo_Info_Info,
    MediaInfo_Info_HowTo,
    MediaInfo_Info_Max
} MediaInfo_info_C;

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/***************************************************************************/
/*! \file MediaInfoDll.h
\brief DLL wrapper for MediaInfo.h.

DLL wrapper for MediaInfo.h \n
    Can be used for C and C++\n
    "Handle" replaces class definition
*/
/***************************************************************************/

#define MediaInfo_New               MediaInfoA_New
#define MediaInfo_Delete            MediaInfoA_Delete
#define MediaInfo_Open              MediaInfoA_Open
#define MediaInfo_Close             MediaInfoA_Close
#define MediaInfo_Inform            MediaInfoA_Inform
#define MediaInfo_GetI              MediaInfoA_GetI
#define MediaInfo_Get               MediaInfoA_Get
#define MediaInfo_Option            MediaInfoA_Option

/** @brief A 'new' MediaInfo interface, return a Handle, don't forget to delete it after using it*/
MEDIAINFO_EXP void*             __stdcall MediaInfoA_New (); /*you must ALWAYS call MediaInfo_Delete(Handle) in order to free memory*/
/** @brief Delete a MediaInfo interface*/
MEDIAINFO_EXP void              __stdcall MediaInfoA_Delete (void* Handle);
/** @brief Wrapper for MediaInfoLib::MediaInfo::Open (with a filename)*/
MEDIAINFO_EXP size_t            __stdcall MediaInfoA_Open (void* Handle, const char* File); /*you must ALWAYS call MediaInfo_Close(Handle) in order to free memory*/
/** @brief Wrapper for MediaInfoLib::MediaInfo::Close */
MEDIAINFO_EXP void              __stdcall MediaInfoA_Close (void* Handle);
/** @brief Wrapper for MediaInfoLib::MediaInfo::Inform */
MEDIAINFO_EXP const char*       __stdcall MediaInfoA_Inform (void* Handle, size_t Reserved); /*Default : Reserved=MediaInfo_*/
/** @brief Wrapper for MediaInfoLib::MediaInfo::Get */
MEDIAINFO_EXP const char*       __stdcall MediaInfoA_GetI (void* Handle, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, MediaInfo_info_C InfoKind); /*Default : InfoKind=Info_Text*/
/** @brief Wrapper for MediaInfoLib::MediaInfo::Get */
MEDIAINFO_EXP const char*       __stdcall MediaInfoA_Get (void* Handle, MediaInfo_stream_C StreamKind, size_t StreamNumber, const char* Parameter, MediaInfo_info_C InfoKind, MediaInfo_info_C SearchKind); /*Default : InfoKind=Info_Text, SearchKind=Info_Name*/
/** @brief Wrapper for MediaInfoLib::MediaInfo::Option */
MEDIAINFO_EXP const char*       __stdcall MediaInfoA_Option (void* Handle, const char* Option, const char* Value);

#ifdef __cplusplus
}
#endif /*__cplusplus*/



#ifdef __cplusplus
//DLL C++ wrapper for C functions
#if !defined(MediaInfoH) && !defined(MEDIAINFO_DLL_EXPORT) //No Lib include and No DLL construction

//---------------------------------------------------------------------------
#include <string>
//---------------------------------------------------------------------------

namespace MediaInfoDLL
{

//---------------------------------------------------------------------------
//Char types
#undef  __T
#define __T(__x)    __T(__x)
#if defined(UNICODE) || defined(_UNICODE)
    typedef wchar_t Char;
    #undef  __T
    #define __T(__x) L ## __x
#else
    typedef char Char;
    #undef  __T
    #define __T(__x) __x
#endif
typedef std::basic_string<Char>        String;
typedef std::basic_stringstream<Char>  StringStream;
typedef std::basic_istringstream<Char> tiStringStream;
typedef std::basic_ostringstream<Char> toStringStream;
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
/// @brief Kinds of Stream
enum stream_t
{
    Stream_General,                 ///< StreamKind = General
    Stream_Video,                   ///< StreamKind = Video
    Stream_Audio,                   ///< StreamKind = Audio
    Stream_Text,                    ///< StreamKind = Text
    Stream_Other,                   ///< StreamKind = Other
    Stream_Image,                   ///< StreamKind = Image
    Stream_Menu,                    ///< StreamKind = Menu
    Stream_Max,
};

/// @brief Kind of information
enum info_t
{
    Info_Name,                      ///< InfoKind = Unique name of parameter
    Info_Text,                      ///< InfoKind = Value of parameter
    Info_Measure,                   ///< InfoKind = Unique name of measure unit of parameter
    Info_Options,                   ///< InfoKind = See infooptions_t
    Info_Name_Text,                 ///< InfoKind = Translated name of parameter
    Info_Measure_Text,              ///< InfoKind = Translated name of measure unit
    Info_Info,                      ///< InfoKind = More information about the parameter
    Info_HowTo,                     ///< InfoKind = Information : how data is found
    Info_Max
};

//---------------------------------------------------------------------------
class MediaInfo
{
public :
    MediaInfo ()                {Handle=MediaInfo_New();};
    ~MediaInfo ()               {MediaInfo_Delete(Handle);};

    //File
    size_t Open (const String &File) {return MediaInfo_Open(Handle, File.c_str());};
    void Close () {return MediaInfo_Close(Handle);};

    //General information
    String Inform ()  {return MediaInfo_Inform(Handle, 0);};
    String Get (stream_t StreamKind, size_t StreamNumber, size_t Parameter, info_t InfoKind=Info_Text)  {return MediaInfo_GetI (Handle, (MediaInfo_stream_C)StreamKind, StreamNumber, Parameter, (MediaInfo_info_C)InfoKind);};
    String Get (stream_t StreamKind, size_t StreamNumber, const String &Parameter, info_t InfoKind=Info_Text, info_t SearchKind=Info_Name)  {return MediaInfo_Get (Handle, (MediaInfo_stream_C)StreamKind, StreamNumber, Parameter.c_str(), (MediaInfo_info_C)InfoKind, (MediaInfo_info_C)SearchKind);};
    String        Option (const String &Option, const String &Value=__T(""))  {return MediaInfo_Option (Handle, Option.c_str(), Value.c_str());};

private :
    void* Handle;
};

} //NameSpace
#endif//#if !defined(MediaInfoH) && !defined(MEDIAINFO_DLL_EXPORT) && !(defined(UNICODE) || defined(_UNICODE))
#endif /*__cplusplus*/

#endif
