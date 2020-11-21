import { Elm } from './Main.elm'

const calc = (source: string) =>
    new Promise((res, rej) => {
        const app = Elm.Main.init({ flags: source })
        app.ports.output.subscribe(result => result ? res(result) : rej(new Error('failed')))
    })

const main = async () => {
    try {
        const r = await calc('p1ass(1998, 11 / 24)')
        console.log(JSON.stringify(r, null, 2))
    } catch(e) {
        console.error(e)
    }
}

main()
