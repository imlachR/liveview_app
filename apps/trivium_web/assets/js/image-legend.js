const ImageLegend = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-image-legend", {legend: this.el.innerText,  id: this.el.dataset.mediaId});
    });
  }
}

export default ImageLegend
