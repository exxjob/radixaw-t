use std::cmp::max;
use itertools::Itertools;
use debug_print::{debug_print, debug_println, debug_eprint, debug_eprintln};

const DUPLICATE_CHARACTERS_ALLOWED: bool = false;
const ILLEGAL_CHARACTERS: [char; 0] =[];
fn radices_convert(input: &[char], in_radix: &[char], out_radix: &[char]) -> Vec<char> {
    #[cfg(debug_assertions)]{

        fn conforms(basis:&[char], examine:&[char], should_contain:bool) ->bool{ for i in examine{ if should_contain != basis.contains(i) { return false; } } return true; }
        pub fn sanitize_duplicate_characters(i:&[char]) -> Vec<char> {
            let mut v = Vec::from_iter(i.iter().copied());  // copied to ensure v owns its data
            v.sort(); v.dedup(); return v;
        }
        debug_assert!(input.len()>0,"Value to convert must not be empty");
        debug_assert!(in_radix.len()>=2 && out_radix.len()>=2, "Radices must be larger");
        debug_assert!(in_radix!=out_radix,"Can't convert between identical representations");
        debug_assert!(DUPLICATE_CHARACTERS_ALLOWED || (in_radix.iter().all_unique() && out_radix.iter().all_unique()), "Radices must not have duplicate characters");
        debug_assert!(ILLEGAL_CHARACTERS.len()==0 || (conforms(&ILLEGAL_CHARACTERS, sanitize_duplicate_characters(in_radix).as_slice(), false) && conforms(&ILLEGAL_CHARACTERS, sanitize_duplicate_characters(out_radix).as_slice(), false)), "Radices must not include illegal characters");
        debug_assert!(conforms(in_radix,sanitize_duplicate_characters(input).as_slice(),true),"Input must only include characters from its Radix");
    }


    fn add(x: & Vec<usize>, y: & Vec<usize>, base:usize) ->Vec<usize>{
        let mut z: Vec<usize> = Vec::new();

        let n:usize = max(x.len(),y.len());
        let mut carry:usize = 0;
        let mut i:usize = 0;
        while i < n || carry > 0 {
            let xi = if i < x.len() { x[i] } else { 0 };
            let yi = if i < y.len() { y[i] } else { 0 };
            let zi = carry + xi + yi;
            z.push(zi % base);
            carry = zi / base;  // todo check does this round down?
            i += 1
        }
        return z;
    }
    fn multiply_by_number(mut num: usize, power: &mut Vec<usize>, base:usize) -> Vec<usize> {
        // if num == 0 { return &mut [0];}
        // if num == 0 { return Vec<us>::new()[0];}
        if num == 0 {
            let mut m: Vec<usize> = Vec::new();
            m.push(0);
            return m;
        }

        let mut result: Vec<usize> = Vec::new();
        let mut z = power.clone();
        loop {
            if num & 1 > 0 { result = add(&result, &z, base); }
            num = num >> 1;
            if num == 0 { break; }
            z = add( &z,  &z, base);
        }
        return result;
    }

    fn decode(input: &[char], in_radix: &[char]) -> Vec<usize> {
        let mut digits: Vec<usize> = vec![];
        debug_println!("[decode func]");
        debug_println!("input of size {} = {:?}",input.len(),input);
        debug_println!("in_radix of size {} = {:?}",in_radix.len(),in_radix);
        debug_println!("entering loop:");
        // for i in (input.len() - 1)..0 {
        for i in (0..input.len()).rev() {
            debug_println!("i = {}",i);
            debug_println!("input[i] = {}",input[i]);
            digits.push(in_radix.iter().position(|&r| r == input[i]).unwrap());
        }
        return digits;
    }

    let from_base = in_radix.len();
    let to_base = out_radix.len();
    let mut out_array: Vec<usize>= Vec::new();
    let mut power: Vec<usize> = vec![1];

    let digits = decode(input, in_radix);
    for i in 0..input.len(){
        out_array = add(&mut out_array, &mut multiply_by_number(digits[i], &mut power, to_base), to_base);
        power = multiply_by_number(from_base, &mut power, to_base);
    }

    let mut out:Vec<char> = vec![];
    for i in (0..out_array.len()).rev() {
        out.push(out_radix[out_array[i]]);
    }
    return out;
}
