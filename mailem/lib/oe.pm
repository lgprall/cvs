package oe;

require Exporter;
@ISA	= qw( Exporter );
@EXPORT	= qw( %oe_win );

%oe_win = ( MIME_HEADERS => qq[MIME-Version: 1.0
Content-type: multipart/mixed;
	boundary="----=_NextPart_000_0005_01BF47C5.62637D80"
],

            BOUNDARY => "----=_NextPart_000_0005_01BF47C5.62637D80",

            SUBBOUNDARY => "----=_NextPart_001_0006_01BF47C5.62637D80",

            HEADERS => qq[X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 5.00.2919.6600
X-MimeOLE: Produced By Microsoft MimeOLE V5.00.2919.6600],

            HTML_LINE => '<DIV><FONT face=3DArial size=3D2>HTML_TEXT</FONT></DIV></BODY></HTML>',

            PREAMBLE => qq[
This is a multi-part message in MIME format.

------=_NextPart_000_0005_01BF47C5.62637D80],

            TEXT => qq[Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_0006_01BF47C5.62637D80"


------=_NextPart_001_0006_01BF47C5.62637D80
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

REPLACEMENT_TEXT
------=_NextPart_001_0006_01BF47C5.62637D80
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Diso-8859-1" =
http-equiv=3DContent-Type>
<META content=3D"MSHTML 5.00.2919.6307" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
REPLACEMENT_HTML

------=_NextPart_001_0006_01BF47C5.62637D80--
],

);
1;
