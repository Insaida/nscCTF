apiOffline =
  About: "/about"
  News: "/news"

mentorLoggedIn =
  Problems: "/problems"
  Shell: "/shell"
  Scoreboard: "/scoreboard"
  Classroom: "/classroom"
  About:
    About: "/about"
    News: "/news"
  Account:
    Manage: "/account"
    Logout: "#"

mentorLoggedInNoCompetition =
  Classroom: "/classroom"
  About: "/about"
  News: "/news"
  Account:
    Manage: "/account"
    Logout: "#"

userLoggedIn =
  Problems: "/problems"
  Shell: "/shell"
  Team: "/team"
  Chat: "/chat"
  Scoreboard: "/scoreboard"
  About:
    About: "/about"
    News: "/news"
  Account:
    Manage: "/account"
    Logout: "#"

userLoggedInNoCompetition =
  Team: "/team"
  Chat: "/chat"
  Scoreboard: "/scoreboard"
  About:  
    About: "/about"
    News: "/news"
  Account:
    Manage: "/account"
    Logout: "#"


userNotLoggedIn =
  About: "/about"
  News: "/news"
  Scoreboard: "/scoreboard"
  Login: "/login"

loadNavbar = (renderNavbarLinks, renderNestedNavbarLinks) ->

  navbarLayout = {
    renderNavbarLinks: renderNavbarLinks,
    renderNestedNavbarLinks: renderNestedNavbarLinks
  }

  apiCall "GET", "/api/user/status", {}
  .done (data) ->
    navbarLayout.links = userNotLoggedIn
    navbarLayout.topLevel = true
    if data["status"] == 1
      if not data.data["logged_in"]
        $(".show-when-logged-out").css("display", "inline-block")
      if data.data["mentor"]
        if data.data["competition_active"]
           navbarLayout.links = mentorLoggedIn
        else
           navbarLayout.links = mentorLoggedInNoCompetition
      else if data.data["logged_in"]
         if data.data["competition_active"]
            navbarLayout.links = userLoggedIn
         else
            navbarLayout.links = userLoggedInNoCompetition
    $("#navbar-links").html renderNavbarLinks(navbarLayout)
    $("#navbar-item-logout").on("click", logout)

  .fail ->
    navbarLayout.links = apiOffline
    $("#navbar-links").html renderNavbarLinks(navbarLayout)

$ ->
  renderNavbarLinks = _.template($("#navbar-links-template").remove().text())
  renderNestedNavbarLinks = _.template($("#navbar-links-dropdown-template").remove().text())

  loadNavbar(renderNavbarLinks, renderNestedNavbarLinks)
