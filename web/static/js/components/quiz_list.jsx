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
        {quiz.name}
      </div>
    );
    return quizzes;
  }
}

QuizList.propTypes = {
  quizzes: React.PropTypes.array
}
