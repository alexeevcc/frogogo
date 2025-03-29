import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js";

export default class extends Controller {
    static targets = ["slider", "value"]

    updateValue() {
        this.valueTarget.textContent = this.sliderTarget.value + ` ₽`;
    }

    async submitValue() {
        const url = this.element.getAttribute("action");
        const formData = new FormData(this.element);
        const options = {
            body: formData,
            responseKind: "turbo-stream"
        }
        const request = new FetchRequest("patch", url, options);
        return await request.perform();
    }
}
