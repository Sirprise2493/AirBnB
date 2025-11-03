import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["whereInput", "suggestions"]

  connect() {
    // Cache important elements from the DOM
    this.navbar = this.element
    this.miniSearch = this.navbar.querySelector(".mini-search-bar")
    this.isExpanded = false // used to track navbar expansion state

    // Static data source - used to track navbar expansion state - replace by API?
    this.destinations = [
      // Europe
      { name: "Paris", country: "France" },
      { name: "London", country: "United Kingdom" },
      { name: "Barcelona", country: "Spain" },
      { name: "Lisbon", country: "Portugal" },
      { name: "Berlin", country: "Germany" },
      { name: "Rome", country: "Italy" },
      { name: "Amsterdam", country: "Netherlands" },
      { name: "Prague", country: "Czech Republic" },
      { name: "Vienna", country: "Austria" },
      { name: "Budapest", country: "Hungary" },
      { name: "Athens", country: "Greece" },
      { name: "Edinburgh", country: "Scotland" },
      { name: "Copenhagen", country: "Denmark" },

      // Americas
      { name: "New York", country: "United States" },
      { name: "Los Angeles", country: "United States" },
      { name: "Miami", country: "United States" },
      { name: "Toronto", country: "Canada" },
      { name: "Vancouver", country: "Canada" },
      { name: "Rio de Janeiro", country: "Brazil" },
      { name: "Buenos Aires", country: "Argentina" },
      { name: "Mexico City", country: "Mexico" },
      { name: "Havana", country: "Cuba" },

      // Asia-Pacific
      { name: "Tokyo", country: "Japan" },
      { name: "Seoul", country: "South Korea" },
      { name: "Bangkok", country: "Thailand" },
      { name: "Singapore", country: "Singapore" },
      { name: "Bali", country: "Indonesia" },
      { name: "Sydney", country: "Australia" },
      { name: "Auckland", country: "New Zealand" },
      { name: "Hong Kong", country: "China" },

      // Middle East & Africa
      { name: "Dubai", country: "United Arab Emirates" },
      { name: "Cape Town", country: "South Africa" },
      { name: "Marrakesh", country: "Morocco" }
    ]

    // Bind all methods
    // Important as event listeners change "this" context
    this.handleScroll = this.handleScroll.bind(this)
    this.handleDocumentClick = this.handleDocumentClick.bind(this)
    this.handleFocusIn = this.handleFocusIn.bind(this)          // NEW
    this.expandMiniSearch = this.expandMiniSearch.bind(this)
    this.onSuggestionClick = this.onSuggestionClick.bind(this)
    this.hideSuggestions = this.hideSuggestions.bind(this)

    // Initialise listeners
    // Run scroll state immediately (for pages not starting at top)
    this.handleScroll()

    // Re-run scroll logic on scroll or page load
    window.addEventListener("scroll", this.handleScroll)
    window.addEventListener("load", this.handleScroll)

    // Detects click outside the navbar
    document.addEventListener("click", this.handleDocumentClick)

    // Detects focus changes between inputs (use capture so it fires early)
    this.navbar.addEventListener("focusin", this.handleFocusIn, true)
    
    // Mini search bar click -> expand full search
    if (this.miniSearch) {
      this.miniSearch.addEventListener("click", this.expandMiniSearch)
    }
  }
  
  disconnect() {
    // Clean up event listeners when controller disconnects
    window.removeEventListener("scroll", this.handleScroll)
    window.removeEventListener("load", this.handleScroll)
    document.removeEventListener("click", this.handleDocumentClick)
    this.navbar.removeEventListener("focusin", this.handleFocusIn, true) // NEW

    if (this.miniSearch) {
      this.miniSearch.removeEventListener("click", this.expandMiniSearch)
    }
  }

  // Scroll behavior
  // When scrolling down past 100px, navbar becomes compact
  handleScroll() {
    if (window.scrollY > 100) {
      this.navbar.classList.add("scrolled")
    } else {
      this.navbar.classList.remove("scrolled")
    }
  }

  // Clicking the mini search bar expands the full version
  expandMiniSearch() {
    this.navbar.classList.remove("scrolled")
  }

  // Outside click detection
  handleDocumentClick(e) {
    const clickedInsideNavbar = this.navbar.contains(e.target)
    const clickedInsideSuggestions =
      this.hasSuggestionsTarget && this.suggestionsTarget.contains(e.target)

    // if user clicks outside navbar and suggestions → close them
    if (!clickedInsideNavbar && !clickedInsideSuggestions) {
      this.hideSuggestions()
      if (window.scrollY > 100) {
        this.navbar.classList.add("scrolled")
      }
    }
  }

  // Focus management
  // Hides suggestions when switching from "Where" input to another field
  handleFocusIn(e) {
    // If focus is inside suggestions, don't hide (lets user click items)
    if (this.hasSuggestionsTarget && this.suggestionsTarget.contains(e.target)) return

    // If the focused element is NOT the "Where" input, hide suggestions
    if (this.hasWhereInputTarget && e.target !== this.whereInputTarget) {
      this.hideSuggestions()
    }
  }

  // Suggestions logic
  // When the "Where" input is focused, show suggestions
  onWhereFocus() {
    const query = this.whereInputTarget.value.trim().toLowerCase()
    this.showSuggestions(query)
  }

  // When user types in "Where", filter destination list
  onWhereInput() {
    const query = this.whereInputTarget.value.trim().toLowerCase()
    this.showSuggestions(query)
  }
  
  // When pressing Escape key, hide the dropdown
  onWhereKeydown(e) {
    if (e.key === "Escape") {
      this.hideSuggestions()
    }
  }

  // Render & display suggestion list
  showSuggestions(query) {
    let matches

    // If no text -> show top 5 destinations as defaults
    if (!query) {
      matches = this.destinations.slice(0, 5)
    } else {
      // Only include destinations that start with entered letters
      matches = this.destinations.filter(d =>
        d.name.toLowerCase().startsWith(query)
      )
    }
    
    // If no matches, show an empty message
    if (matches.length === 0) {
      this.suggestionsTarget.innerHTML = `<div class="empty">No results found</div>`
      this.suggestionsTarget.hidden = false
      return
    }
    
    // Otherwise, display the matches in the dropdown
    this.suggestionsTarget.innerHTML = matches.map(d => `
      <div class="suggestion-item" data-name="${this.escape(d.name)}">
        <span class="icon">📍</span>
        <div class="text">
          <span class="primary">${this.escape(d.name)}</span>
          <span class="secondary">${this.escape(d.country)}</span>
        </div>
      </div>
    `).join("")
    
    // Make the dropdown visible
    this.suggestionsTarget.hidden = false
    
    // Add event listeners to each suggestion item
    this.suggestionsTarget.querySelectorAll(".suggestion-item").forEach(item => {
      item.addEventListener("mousedown", this.onSuggestionClick)
    })
  }

  // When user clicks on a suggestion -> fill the input and close dropdown
  onSuggestionClick(e) {
    e.preventDefault()
    const name = e.currentTarget.dataset.name
    this.whereInputTarget.value = name
    this.hideSuggestions()
  }

  // Hide dropdown list
  hideSuggestions() {
    if (this.hasSuggestionsTarget) {
      this.suggestionsTarget.hidden = true
    }
  }

  // Safely escape text for HTML rendering
  escape(str) {
    return String(str).replace(/[&<>"']/g, s => ({
      "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"
    }[s]))
  }
}
