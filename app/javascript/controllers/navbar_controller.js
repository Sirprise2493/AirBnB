import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  connect() {
    this.navbar = this.element
    this.miniSearch = this.navbar.querySelector(".mini-search-bar")

    // Bind methods so they can be added/removed as listeners safely
    this.handleScroll = this.handleScroll.bind(this)
    this.handleClickOutside = this.handleClickOutside.bind(this)
    this.expandMiniSearch = this.expandMiniSearch.bind(this)

    // Initial check + listeners
    this.handleScroll()
    window.addEventListener("scroll", this.handleScroll)
    window.addEventListener("load", this.handleScroll)
    document.addEventListener("click", this.handleClickOutside)

    if (this.miniSearch) {
      this.miniSearch.addEventListener("click", this.expandMiniSearch)
    }
  }

  disconnect() {
    // Clean up listeners when Turbo navigates
    window.removeEventListener("scroll", this.handleScroll)
    window.removeEventListener("load", this.handleScroll)
    document.removeEventListener("click", this.handleClickOutside)

    if (this.miniSearch) {
      this.miniSearch.removeEventListener("click", this.expandMiniSearch)
    }
  }

  handleScroll() {
    if (window.scrollY > 100) {
      this.navbar.classList.add("scrolled")
    } else {
      this.navbar.classList.remove("scrolled")
    }
  }

  handleClickOutside(e) {
    if (!this.navbar.contains(e.target) && window.scrollY > 100) {
      this.navbar.classList.add("scrolled")
    }
  }

  expandMiniSearch() {
    this.navbar.classList.remove("scrolled")
  }
}