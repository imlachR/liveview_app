const Quiz = {
  mounted() {
    var quizess = this.el.querySelectorAll(".quiz__layer--1");

    for (var i = 0; i < quizess.length; i++) {
      var letter = quizess[i].querySelector('div');
      letter.innerText = `${(i+10).toString(36)}`;
    }
  },

  updated() {
    var quizess = this.el.querySelectorAll(".quiz__layer--1");

    for (var i = 0; i < quizess.length; i++) {
      var letter = quizess[i].querySelector('div');
      letter.innerText = `${(i+10).toString(36)}`;
    }
  }
}

export default Quiz
