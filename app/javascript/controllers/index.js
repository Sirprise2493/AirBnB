// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Import (calendar)
import { application } from "./application"
import BookingNewController from "./booking_new_controller.js"
application.register("booking-new", BookingNewController)