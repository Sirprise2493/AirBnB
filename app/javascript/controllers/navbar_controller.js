import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["whereInput", "suggestions"]

  connect() {
    this.navbar = this.element
    this.miniSearch = this.navbar.querySelector(".mini-search-bar")
    this.isExpanded = false

    // Local destinations (temporary static data)
    this.destinations = [
      { name: "Paris", country: "France" },
      { name: "London", country: "United Kingdom" },
      { name: "New York", country: "United States" },
      { name: "Tokyo", country: "Japan" },
      { name: "Barcelona", country: "Spain" },
      { name: "Lisbon", country: "Portugal" },
      { name: "Berlin", country: "Germany" },
      { name: "Rome", country: "Italy" },
      { name: "Sydney", country: "Australia" },
      { name: "Bali", country: "Indonesia" },
    ]

    // Bind methods
    this.handleScroll = this.handleScroll.bind(this)
    this.handleDocumentClick = this.handleDocumentClick.bind(this)
    this.expandMiniSearch = this.expandMiniSearch.bind(this)
    this.onSuggestionClick = this.onSuggestionClick.bind(this)

    // Init listeners
    this.handleScroll()
    window.addEventListener("scroll", this.handleScroll)
    window.addEventListener("load", this.handleScroll)
    document.addEventListener("click", this.handleDocumentClick)

    if (this.miniSearch) {
      this.miniSearch.addEventListener("click", this.expandMiniSearch)
    }
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
    window.removeEventListener("load", this.handleScroll)
    document.removeEventListener("click", this.handleDocumentClick)

    if (this.miniSearch) {
      this.miniSearch.removeEventListener("click", this.expandMiniSearch)
    }
  }

  // ===== Scroll behavior =====
  handleScroll() {
    if (window.scrollY > 100) {
      this.navbar.classList.add("scrolled")
    } else {
      this.navbar.classList.remove("scrolled")
    }
  }

  expandMiniSearch() {
    this.navbar.classList.remove("scrolled")
  }

  // ===== Outside click detection =====
  handleDocumentClick(e) {
    const clickedInsideNavbar = this.navbar.contains(e.target)
    const clickedInsideSuggestions = this.hasSuggestionsTarget && this.suggestionsTarget.contains(e.target)

    // if clicked outside navbar and suggestions → close them
    if (!clickedInsideNavbar && !clickedInsideSuggestions) {
      this.hideSuggestions()
      if (window.scrollY > 100) {
        this.navbar.classList.add("scrolled")
      }
    }
  }

  // ===== Suggestions logic =====
  onWhereFocus() {
    const query = this.whereInputTarget.value.trim().toLowerCase()
    this.showSuggestions(query)
  }

  onWhereInput() {
    const query = this.whereInputTarget.value.trim().toLowerCase()
    this.showSuggestions(query)
  }

  onWhereKeydown(e) {
    if (e.key === "Escape") {
      this.hideSuggestions()
    }
  }

  showSuggestions(query) {
    let matches
    if (!query) {
      matches = this.destinations.slice(0, 5)
    } else {
      matches = this.destinations.filter(d =>
        d.name.toLowerCase().startsWith(query)
      )
    }

    if (matches.length === 0) {
      this.suggestionsTarget.innerHTML = `<div class="empty">No results found</div>`
      this.suggestionsTarget.hidden = false
      return
    }

    this.suggestionsTarget.innerHTML = matches.map(d => `
      <div class="suggestion-item" data-name="${this.escape(d.name)}">
        <span class="icon">📍</span>
        <div class="text">
          <span class="primary">${this.escape(d.name)}</span>
          <span class="secondary">${this.escape(d.country)}</span>
        </div>
      </div>
    `).join("")

    this.suggestionsTarget.hidden = false

    this.suggestionsTarget.querySelectorAll(".suggestion-item").forEach(item => {
      item.addEventListener("mousedown", this.onSuggestionClick)
    })
  }

  onSuggestionClick(e) {
    e.preventDefault()
    const name = e.currentTarget.dataset.name
    this.whereInputTarget.value = name
    this.hideSuggestions()
  }

  hideSuggestions() {
    if (this.hasSuggestionsTarget) {
      this.suggestionsTarget.hidden = true
    }
  }

  escape(str) {
    return String(str).replace(/[&<>"']/g, s => ({
      "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"
    }[s]))
  }
}
