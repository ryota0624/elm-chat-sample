document.body.innerHTML = ""; var elm = Elm.Main.fullscreen();
elm.ports.receiveLoginUser.send({ userId: 100, name: "SUZUKI", iconImageUrl: "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" });


elm.ports.receiveTalkCollectionResource.send([
    {
        userId: 100,
        userName: "SUZUKI",
        userIconImageUrl: "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg",
        text: "HELLO",
        talkId: 1,
        createdAt: (new Date).getTime()
    },
    {
        userId: 200,
        userName: "RYOTA",
        userIconImageUrl: "https://grapee.jp/wp-content/uploads/32187_main2.jpg",
        text: "にゃーん",
        talkId: 2,
        createdAt: (new Date).getTime()
    }
]);

elm.ports.requestPostTalk.subscribe(data => console.log(data))


// type alias TalkPortDto = {
//     userId: Int,
//     userName: String,
//     userIconImageUrl: String,
//     text: String,
//     talkId: Int,
//     createdAt: Time
// }
