// Approved presentation constants; unsupported acquisition still yields unavailable.
module PresentationPolicy {
    // DEC-DURATION: user approved MM:SS below one hour on 2026-10-13.
    const PAD_LEADING_MINUTES = true;
    const ZONE_UPPER_INCLUSIVE = true;
    const USE_ROUNDED_POWER_FOR_ZONE = true;
    // APP-35: only the approved unavailable and overflow markers are reachable.
    const UNAVAILABLE = "--";
    const OVERFLOW = "!";
}
