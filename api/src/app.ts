import express from 'express'
import {json} from 'body-parser'
require('dotenv').config()

const {PORT} = process.env

const app = express()
app.use(json())

let queue = []
app.post('/pawn', (req,res) => {
    const {killer,victim, room} = req.body
    queue.push({
        type: 'pawn',
        killer: killer,
        victim: victim,
        room: room
    })
    res.sendStatus(204)
})
app.post('/survive', (req,res) => {
    const {survivor, room} = req.body
    queue.push({
        type: 'survive',
        survivor: survivor,
        room: room
    })
    res.sendStatus(204)
})
app.get('/queue/:shift', (req,res) => {
    console.log(queue)
    const {shift} = req.params
    for(let i=0;i<parseInt(shift);i++) queue.shift()
    let result = []
    for(let i=0;i<queue.length;i++) {
        result.push(queue[i])
    }
    res.send(result)
})

app.listen(PORT, () => {
    console.log('server start')
})