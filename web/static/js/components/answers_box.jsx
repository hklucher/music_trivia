import React from "react"
import ReactDOM from "react-dom"

export class AnswersBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    if (this.props.data) {
      return (
        <div>
          {this.props.data.name}
        </div>
      )
    } else {
      return (<div></div>)
    }
  }
}
