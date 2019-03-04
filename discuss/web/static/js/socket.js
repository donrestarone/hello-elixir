import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  // pass the comment Id to the join function of the comments channel
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", response => { 
        console.log(response)
        // this is where you get the comments/data the server is streaming
        renderComments(response.comments)
     })
    .receive("error", resp => { console.log("Unable to join", resp) })
    
    // this is to listen to the event broadcasted by handle_in function in the comments channel
    // when that event fires, we will run render comment
    channel.on(`comments:${topicId}:new`, renderComment)

    document.querySelector('button').addEventListener('click', () => {
      const content = document.querySelector('textarea').value

      // call the handle_in function on the phx side (in comments channel)
      channel.push('comment:add', {content: content})
    })
}

const renderComment = (event) => {
  const renderedComment = commentTemplate(event.comment)

  document.querySelector('.collection').innerHTML += renderedComment

}
const commentTemplate = (commentObject) => {
  return `
    <li class="collection-item">
      ${commentObject.content}
    </li>
  `
}
const renderComments = (comments) => {
  const renderedComments = comments.map((comment, index) => {
    return (commentTemplate(comment))
  })
  document.querySelector('.collection').innerHTML = renderedComments.join('')
}




window.createSocket = createSocket
