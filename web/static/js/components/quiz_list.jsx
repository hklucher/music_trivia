import React from "react"
import ReactDOM from "react-dom"

export class QuizList extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return(
      <div className="container">
        {this._listQuizzes()}
      </div>
    )
  }

  _listQuizzes() {
    const quizzes = this.props.quizzes.map((quiz) =>
      <div className="quiz_column" key={quiz.id}>
        {this._titleizeQuiz(quiz.name)}
      </div>
    );
    return quizzes;
  }

  _titleizeQuiz(quizName) {
    const words = quizName.split(" ");
    const capitalized = words.map((word) =>
      word.charAt(0).toUpperCase() + word.slice(1)
    );
    return capitalized.join(" ");
  }
}

QuizList.propTypes = {
  quizzes: React.PropTypes.array
}
