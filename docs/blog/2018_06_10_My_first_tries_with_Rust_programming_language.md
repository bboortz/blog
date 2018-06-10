# My first tries with Rust programming language

The last months I have seen a lot of blog that are writing about the Rust programming language. Sometimes how good it is, sometimes why it is better then other programming languages. 
Then I have seen a blog series [Writing an OS in Rust](https://os.phil-opp.com/) and [Writing an OS in Rust - Second Edition](https://os.phil-opp.com/second-edition/).
I thought myself why not give Rust a try. 


# Goals

Inspired by this I am trying Rust a few hours, understanding principles and design goals, and build something really simple.
Therefore I will read some documenation, setup my local dev environment, will develop a hello world program and after that a bit more complex program.



# Process 

## Investigations

I have started my work with reading some documentation, esspecially:

* [The Rust Programming Language](https://www.rust-lang.org/)
* [The Rust Design FAQ](https://doc.rust-lang.org/1.4.0/complement-design-faq.html)
* [Diving into Rust for the first time - Mozilla Hacks](https://hacks.mozilla.org/2015/05/diving-into-rust-for-the-first-time/)
* [Interview with Steve Klabnik: How Rust Compares to Other Languages and More](https://www.codementor.io/steveklabnik/interview-with-steve-klabnik-how-rust-compares-to-other-languages-and-more-8t5ut6nau)



## Setting up a local dev environment

First I had to install the software package rustup. It is described how to achieve that on the rust website. 
Unfortunately was the Arch Linux rustup package which I have installed via pacman not working for me. 
It seems for the the problem was that I missed to configure a default toolchain. I havn't followed this approach.
So that I decided to go with the default install doc [Install Rust](https://www.rust-lang.org/en-US/install.html)

```
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
```

In case you want to update your installation, simple type in:

```
rustup update && cargo update
```


After that I have checked the version of the installed rust compiler using

```
$ rustc --version && cargo --version
rustc 1.26.2 (594fb253c 2018-06-01)
cargo 1.26.0 (0e7c5a931 2018-04-06)
```

My current local rust/cargo installation is 13 MB big which is quite small:

```
$ du -sh ~/.cargo
13M	/home/benni/.cargo
```

I have decided to use vi as a editor. So that it is not needed to install any IDE.



## Hello World Program

Our first program is a hello world programm which only prints out "Hello World"

Create the file "hello.rs" with this content:

```
/// The main function
fn main() {
    // Print text
    println!("Hello World!");
}
```


Compile the program

```
rustc hello.rs
```

And run it

```
./hello
```

You will see the expected output.



## A serious example

After we have installed rust and have compiled our first program we are now using rust for a more serious example.
What means serius? Nowadays has everything an API. Therefore we are developing a simple REST API plus showing how to test rust source code.

Developing a REST application efforts a lot more knowledge about Rust. Therefore I read a bunch of ressources

* [rustless/rustless](https://github.com/rustless/rustless)
* [Build a CRUD API with Rust](https://medium.com/sean3z/building-a-restful-crud-api-with-rust-1867308352d8)
* [Are we web yet?](http://www.arewewebyet.org/)

### Creating the REST API

Creating the project

```
$ cargo new hello-api --bin && cd hello-api
     Created binary (application) `hello-api` project
```

Adding the dependencies to file Cargo.toml

```
[dependencies]
rocket = "0.3.12"
rocket_codegen = "0.3.12"
serde = "1.0"
serde_json = "1.0"
serde_derive = "1.0"

[dependencies.rocket_contrib]
default-features = false
features = ["json"]
#path = "../Rocket/contrib/lib"
```

Adding the needed source code to src/main.rs

```
#![feature(plugin, decl_macro)]
#![plugin(rocket_codegen)]

extern crate rocket;
#[macro_use] extern crate rocket_contrib;
#[macro_use] extern crate serde_derive;

#[cfg(test)] mod tests;

use rocket_contrib::{Json, Value};


#[derive(Serialize, Deserialize)]
struct HelloInput{
    name: String
}


#[get("/", format = "application/json")]
fn index() -> Json<Value> {
    Json(json!({
        "status": "OK",
    }))
}

#[post("/", format = "application/json", data = "<json_input>")]
fn hello(json_input: Json<HelloInput>) -> Json<Value> {
    Json(json!({
        "hello": json_input.name,
    }))
}

#[error(404)]
fn not_found() -> Json<Value> {
    Json(json!({
        "status": "error",
        "reason": "Resource was not found."
    }))
}

fn rocket() -> rocket::Rocket {
    rocket::ignite()
        .mount("/", routes![index])
        .mount("/hello", routes![hello])
        .catch(errors![not_found])
}

fn main() {
    rocket().launch();
}
```

Compiling the software

```
cargo build
```

This build has failed with the error message "*Installed version is: 1.26.2 (2018-06-01). Minimum required: 1.27.0-nightly (2018-04-26).*".
Therefore we are updating the installation to nigthly using this commands:

```
rustup default nightly
rustup update && cargo update
```

Now we are using the following versions:

```
$ rustc --version && cargo --version
rustc 1.28.0-nightly (2a0062974 2018-06-09)
cargo 1.28.0-nightly (e2348c2db 2018-06-07)
```

Now we are building again

```
$ cargo build
[...]
Finished dev [unoptimized + debuginfo] target(s) in 53.42s
```

Looks good. So let us run the REST API.

```
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.06s
     Running `target/debug/hello-api`
🔧  Configured for development.
    => address: localhost
    => port: 8000
    => log: normal
    => workers: 8
    => secret key: generated
    => limits: forms = 32KiB
    => tls: disabled
🛰  Mounting '/hello':
    => GET /hello/<name>/<age>
🚀  Rocket has launched from http://localhost:8000
```

Let's test the REST API with a GET /

```
$ curl http://localhost:8000/
{"status":"OK"}
```


Ant now with a POST /hello with some input data:

```
$ curl  \
  --request POST \
  --header "Content-Type: application/json" \
  --data '{"name":"benni"}' \
  http://localhost:8000/hello
{"hello":"benni"}
```


### Testing our Software

Test cases are important to validate our API. So that we are writing up a few unit test. Just add these lines in "src/tests.rs

```
use rocket;
use rocket::local::Client;
use rocket::http::{Status, ContentType};

#[test]
fn test_not_found() {
        let client = Client::new(rocket()).unwrap();

    let res = client.get("/not_found")
            .header(ContentType::JSON)
                .dispatch();
    assert_eq!(res.status(), Status::NotFound);
}

#[test]
fn test_alive() {
        let client = Client::new(rocket()).unwrap();

    let mut res = client.get("/")
            .header(ContentType::JSON)
                .dispatch();
    let body = res.body_string().unwrap();
    assert_eq!(res.status(), Status::Ok);
    assert!(body.contains("OK"));
}

#[test]
fn test_post_hello() {
        let client = Client::new(rocket()).unwrap();

    let mut res = client.post("/hello")
        .header(ContentType::JSON)
        .body(r#"{ "name": "benni" }"#)
        .dispatch();

    assert_eq!(res.status(), Status::Ok);
        let body = res.body().unwrap().into_string().unwrap();
        assert!(body.contains("hello"));
}
```

And run:

```
$ cargo test
[...]
test result: ok. 3 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out
```

# Conclusion

My first try with Rust took me about 6 hours. After 6 hours I am able write very simple programs including test cases and I am able to work with Rust CLI and dependencies.
1 1/2 year ago I have learned go. With go I had a really great learning curve. 
Right now I made with Rust my very first steps but it seems for me Rust is not very hard to learn if you are familiar with C/C++ like languages.
What I really apprechiate after my first "work" with Rust is:

* The existing toolchain with good cli commands
* the existing dependency management
* The integrated unit testing

On the other side of the coin I have to say that the Rust syntax feels a bit strange for me. Especially Rust macros and the extern statement are parts which I am copy-and-paste right now. 
I guess I need to use it more often then it becomes easier.

From this starting point I am planning to invest a bit more time into Rust to see if it fits for my personal purposes.



# Links

* [Rocket](https://rocket.rs/)
* [Rocket API](https://api.rocket.rs/rocket/)
* [SergioBenitez/Rocket](https://github.com/SergioBenitez/Rocket)


---------------------------------------
```
Created: 2018-06-10
Updated: 2018-06-10
```
