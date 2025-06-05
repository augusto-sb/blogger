use std::env;
use std::process::exit;
use std::{
    io::{prelude::*, BufReader},
    net::{TcpListener, TcpStream},
};
use std::time::SystemTime;

//use std::io;
//use std::time::Duration;

fn mylog(lala: String){
    let curr_time = SystemTime::now();
    let mut ts: u64 = 0;
	match curr_time.duration_since(SystemTime::UNIX_EPOCH) {
	    //Ok(n) => println!("1970-01-01 00:00:00 UTC was {} seconds ago!", n.as_secs()),
	    Ok(n) => ts = n.as_secs(),
	    //Err(_) => panic!("SystemTime before UNIX EPOCH!"),
	    Err(_) => {},
	}
    //println!("2025/06/05 13:14:45 {} {}", lala, curr_time.elapsed().unwrap().as_secs()/*tv_sec*/);
    println!("{:-<19} {}", ts, lala);
}

fn main() {
    let mut name_line: String = "".to_string();
    let mut port = 80;

    //let hostname = std::env::hostname();
    //println!("Hostname: {}", hostname.to_string_lossy());
    //println!("{:#?} {:#?}", SystemTime::now(), SystemTime::now().elapsed().unwrap());

    match env::var("WHOAMI_PORT_NUMBER") {
        Ok(val) => {
        	port = val.parse::<u16>().unwrap();
        },
        Err(_e) => {/*ignore*/}
    }
    match env::var("WHOAMI_NAME") {
        Ok(val) => name_line = format!("Name: {val}\n"),
        Err(_e) => {/*ignore*/}
    }

    //let listener_res = TcpListener::bind(format!("127.0.0.1:{}", port));
    //let listener_res = TcpListener::bind(format!("0.0.0.0:{}", port));
    let listener_res = TcpListener::bind(format!("[::]:{}", port)); // more difficult list each ip, every ipv4 and ipv6
    let listener: TcpListener;
    match listener_res {
        Ok(val) => {
            //println!("2025/06/05 13:14:45 Starting up on port {}", val.local_addr().unwrap().port());
            mylog(format!("Starting up on port {}", val.local_addr().unwrap().port()));
            //pretty_print_system_time();
            //print!("2025/06/05 13:14:45 Starting up on port {}", val.local_addr().unwrap().port());
            //io::stdout().flush().unwrap();
            listener = val;
        }
        Err(e) => {
            println!("Error listener {}.", e);
            exit(1);
        }
    }

    //println!("--{}", listener.local_addr().unwrap());

    for stream in listener.incoming() {
        //let stream = stream.unwrap();
        //handle_connection(stream);
        match stream {
            Ok(stream) => {
                handle_connection(stream, name_line.to_string());
            }
            Err(e) => {
                println!("Error stream: {}", e)
            }
        }
    }
}

fn handle_connection(mut stream: TcpStream, name_line: String) {
    let buf_reader = BufReader::new(&stream);
    let http_request: Vec<_> = buf_reader
        .lines()
        .map(|result| result.unwrap())
        .take_while(|line| !line.is_empty())
        .collect();

    //println!("Request: {http_request:#?}");
    //println!("Request: {:#?}", http_request.join("\n"));

	let status_line = "HTTP/1.1 200 OK";
	//let contents = fs::read_to_string("hello.html").unwrap();
	let contents = format!("{}Hostname: xxxxxxxxxxxx\nIP: {}\nRemoteAddr: {}\n{}\n", name_line, stream.local_addr().unwrap().ip(), stream.peer_addr().unwrap(), http_request.join("\n"));
	let length = contents.len();

	let response = format!(
	    "{status_line}\r\nContent-Length: {length}\r\n\r\n{contents}"
	);

	stream.write_all(response.as_bytes()).unwrap();
}
