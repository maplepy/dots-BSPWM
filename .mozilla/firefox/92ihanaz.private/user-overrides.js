




// Overrides (Private)

/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
user_pref("browser.sessionstore.privacy_level", 0); // 1003 optional to restore cookies/formdata
user_pref("privacy.clearOnShutdown.history", false); // 2811
  // user_pref("privacy.cpd.history", false); // 2820 optional to match when you use Ctrl-Shift-Del
user_pref("privacy.clearOnShutdown.siteSettings", "false")

user_pref("browser.startup.homepage", "about:home");

user_pref("browser.newtabpage.enabled", true);

/* 2615: disable websites overriding Firefox's keyboard shortcuts [FF58+]
 * 0 (default) or 1=allow, 2=block ***/
user_pref("permissions.default.shortcuts", 1);

/* 2703: delete cookies and site data on close
* 0=keep until they expire (default), 2=keep until you close Firefox ***/
user_pref("network.cookie.lifetimePolicy", 0);

// Unbug some sites like anticope.ml
user_pref("webgl.disabled", false);

user_pref("keyword.enabled", true);
user_pref("extensions.pocket.enabled", false);


// Remove letterboxing on laptop
user_pref("privacy.resistFingerprinting.letterboxing", false);



user_pref("_user.js.parrot", "SUCCESS: Private profile loaded");
