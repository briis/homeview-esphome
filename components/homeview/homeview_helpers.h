// HomeView helper functions (shared by all widgets)
// Danish localisation + weather condition -> MDI glyph / Apple colour.
#pragma once
#include <string>
#include <cstdint>
#include <algorithm>
#include <cstdio>

namespace hv {

// ---- Danish calendar names ---------------------------------------------
// ESPHome day_of_week: 1 = Sunday ... 7 = Saturday
inline const char *weekday_da(int dow) {
  static const char *const names[] = {"søndag", "mandag", "tirsdag", "onsdag",
                                      "torsdag", "fredag", "lørdag"};
  return (dow >= 1 && dow <= 7) ? names[dow - 1] : "";
}
inline const char *weekday_da_upper(int dow) {
  static const char *const names[] = {"SØNDAG", "MANDAG", "TIRSDAG", "ONSDAG",
                                      "TORSDAG", "FREDAG", "LØRDAG"};
  return (dow >= 1 && dow <= 7) ? names[dow - 1] : "";
}
inline const char *month_da(int month) {
  static const char *const names[] = {"januar", "februar", "marts",     "april",
                                      "maj",    "juni",    "juli",      "august",
                                      "september", "oktober", "november", "december"};
  return (month >= 1 && month <= 12) ? names[month - 1] : "";
}

inline const char *month_da_short_upper(int month) {
  static const char *const names[] = {"JAN.", "FEB.", "MAR.", "APR.", "MAJ",  "JUN.",
                                      "JUL.", "AUG.", "SEP.", "OKT.", "NOV.", "DEC."};
  return (month >= 1 && month <= 12) ? names[month - 1] : "";
}

// Danish number formatting: 3.12 -> "3,12"
inline std::string fmt_da(float value, int decimals) {
  char buf[24];
  snprintf(buf, sizeof(buf), "%.*f", decimals, value);
  std::string s(buf);
  std::replace(s.begin(), s.end(), '.', ',');
  if (s == "-0") s = "0";
  return s;
}

// ---- Weather ----------------------------------------------------------------
inline const char *weather_icon(const std::string &c) {
  if (c == "sunny") return "\U000F0599";
  if (c == "clear-night") return "\U000F0594";
  if (c == "partlycloudy") return "\U000F0595";
  if (c == "cloudy") return "\U000F0590";
  if (c == "fog") return "\U000F0591";
  if (c == "hail") return "\U000F0592";
  if (c == "lightning") return "\U000F0593";
  if (c == "lightning-rainy") return "\U000F067E";
  if (c == "pouring") return "\U000F0596";
  if (c == "rainy") return "\U000F0597";
  if (c == "snowy") return "\U000F0598";
  if (c == "snowy-rainy") return "\U000F067F";
  if (c == "windy") return "\U000F059D";
  if (c == "windy-variant") return "\U000F059E";
  if (c == "exceptional") return "\U000F0F2F";
  return "\U000F0590";
}

// Apple Weather style colours (SF Symbols multicolour approximation)
inline uint32_t weather_color(const std::string &c) {
  if (c == "sunny") return 0xFFD60A;           // yellow
  if (c == "clear-night") return 0xE5E5EA;     // moon white
  if (c == "partlycloudy") return 0xFFD60A;
  if (c == "lightning" || c == "lightning-rainy") return 0xFFD60A;
  if (c == "rainy" || c == "pouring") return 0x64D2FF;  // teal/blue drops
  if (c == "snowy" || c == "snowy-rainy" || c == "hail") return 0xFFFFFF;
  if (c == "exceptional") return 0xFF453A;
  return 0xE5E5EA;                              // clouds, fog, wind
}

inline const char *weather_text_da(const std::string &c) {
  if (c == "sunny") return "Sol";
  if (c == "clear-night") return "Klart";
  if (c == "partlycloudy") return "Delvis skyet";
  if (c == "cloudy") return "Overskyet";
  if (c == "fog") return "Tåge";
  if (c == "hail") return "Hagl";
  if (c == "lightning") return "Torden";
  if (c == "lightning-rainy") return "Torden og regn";
  if (c == "pouring") return "Skybrud";
  if (c == "rainy") return "Regn";
  if (c == "snowy") return "Sne";
  if (c == "snowy-rainy") return "Slud";
  if (c == "windy" || c == "windy-variant") return "Blæsende";
  if (c == "exceptional") return "Advarsel";
  return "–";
}

// Electricity price level -> colour
inline uint32_t price_color(const std::string &level) {
  if (level == "low") return 0x30D158;
  if (level == "high") return 0xFF453A;
  return 0xFFD60A;
}

}  // namespace hv
