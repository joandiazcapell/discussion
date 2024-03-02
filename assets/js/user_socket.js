import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})
  channel.join()
    .receive("ok", resp => { 
      //console.log("Joined successfully", resp.comments)
      console.log("Joined successfully", resp)
      renderComments(resp.comments);
    })
    .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on(`comments:${topicId}:new`, renderComment);

  document.querySelector("#comment-text").addEventListener('click', () => {
    const content = document.querySelector('textarea').value;

    channel.push('comment:add', { content: content});
  });
};

function renderComments(comments) {
  const renderComments = comments.map(comment => {
    return commentTemplate(comment);
  });
  document.querySelector('.collection').innerHTML = renderComments.join('');
};

function renderComment(event){
  const renderComment = commentTemplate(event.comment);

  document.querySelector('.collection').innerHTML += renderComment;
};

function commentTemplate(comment){
  let name = 'Anonymous';
  let email = 'no email';

  if(comment.user) {
    name = comment.user.name;
    email = comment.user.email;
  }

  return `
      <li class="collection-item">
        ${comment.content}
        <div class="secondary-content">
          ${name} - ${email}
        </div>
      </li>
    `;
};

window.createSocket = createSocket;