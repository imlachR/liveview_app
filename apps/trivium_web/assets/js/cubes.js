const Cubes = {
  mounted() {
    console.log("CUBES Mounted", this.el);

    var cubes = document.getElementById('cubes');
    var glass = document.getElementById('modal-glass');
    var glassClose = document.getElementById('glass__close');

    cubes.onclick = function() {
      glass.style.display = "flex";
    }

    glassClose.onclick = function() {
      glass.style.display = "none";
    }

  }
}

export default Cubes
