const Position = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-content-position", {position: this.el.value, id: this.el.dataset.contentId});
    });
  }
}

export default Position
