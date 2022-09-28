// use std::io;

fn main() {

    // let mut input = String::new();
    // io::stdin().read_line(&mut input);

    // borrowing();
    // dereferencing();
    // option_example();
    // let res: String = match_this(1);
    // println!("{}", res); 
    // struct_usage();

    // let x: String = "Petar".to_string();
    // println!("{}", &x);
    // println!("{}", &x);
}

fn borrowing() {
    let mut x: String = String::from("Hello World!");
    let mut y = &x; // borrowing
}

fn dereferencing() {
    let a = 1;
    let b = &a;
    assert_eq!(1, a);
    assert_eq!(1, *b); // dereferencing
    println!("True");
}

// Static value
fn static_val() {
    let static_value: &'static str = "Petar";
}

// usize
fn usize_type() {
    let x: usize = 2; // Depends on OS architecture(x32, x64)
}

enum Option<T> {
    Some(T),
    None,
}

// handling options
fn option_example() {
    let mut vector: Vec<i32> = vec![1, 2, 3];
    for i in 0..5 {
        // println!("{:?} ", vector.pop());
        let x = match vector.pop() {
            Some(val) => val,
            None => 0,
        };
        println!("{}", x);
    }
}

fn match_this(val: i32) -> String {
    match val {
        1 => "One".to_string(),
        2 => "Two".to_string(),
        3 => "Three".to_string(),
        _ => "Not listed".to_string(), // default case
    }
}

// Structs
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
} 

fn initialize_struct() {
    let mut user1 = User { 
        username: String::from("Petar"),
        email: String::from("kovacevic1304@gmail.com"),
        sign_in_count: 34,
        active: false,
    };

    user1.sign_in_count += 1;
    user1.active = true;

    let user2: User = User { 
        username: String::from("New User"),
        email: String::from("othermail@gmail.com"),
        ..user1
    };
}

struct Person {
    first_name: String,
    last_name: String,
}

// implementing methods
impl Person {
    fn details(&self) -> String {
        String::from(&self.last_name)
    }
    // associated function, like a static without self
    fn more_details() -> String {
        String::from("Likes noodles")
    }
}

fn struct_usage() {
    let petar: Person = Person {
        first_name: "Petar".to_string(),
        last_name: "Kovacevic".to_string(),
    };
    println!("{}", petar.details());
    println!("{}", Person::more_details());
}