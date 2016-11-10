import React from "react"
import ReactDom from "react-dom"
import {ResponsesBox} from "./responses_box"

export class Question extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <div>
        <h5>{this.props.content}</h5>
      <ResponsesBox responses={this.props.responses}></ResponsesBox>
      </div>
    )
  }
}
