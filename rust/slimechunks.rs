use std::io::Write;
fn inp<T: std::str::FromStr>(p: &str) -> T {
    loop {
        print!("{}", p);
        if std::io::stdout().flush().is_ok() {
            let mut i = String::new();
            if std::io::stdin().read_line(&mut i).is_ok() {
                if let Ok(o) = i.trim().parse::<T>() {
                    return o;
                }
            }
        }
    }
}
fn main() {
    let max_seeds: u128 = inp("Seeds to benchmark: ");
    let (term_x, term_z) = (sc_term_x(69), sc_term_z(420));
    let mut slime_chunk_count = 0;
    let start_time = std::time::Instant::now();
    for seed in i64::MIN..i64::MIN + max_seeds as i64 {
        slime_chunk_count += is_slime_chunk(term_x, term_z, seed) as u128;
    }
    let end_time = start_time.elapsed().as_micros();
    println!(
        "Execution time in ms: {}, CPS: {}, Slime Chunks: {}",
        end_time,
        (1_000_000_f64 * max_seeds as f64) / end_time as f64,
        slime_chunk_count
    );
}
#[inline(always)]
fn sc_term_x(x: i32) -> u64 {
    (x * x * 4987142) as u64 + (x * 5947611) as u64
}
#[inline(always)]
fn sc_term_z(z: i32) -> u64 {
    (z * z) as u64 * 4392871 + (z * 389711) as u64
}
#[inline(always)]
fn is_slime_chunk(tx: u64, tz: u64, seed: i64) -> bool {
    const MULTIPLIER: i64 = 0x5DEECE66D;
    const MASK: i64 = 0xFFFFFFFFFFFF;
    (((((((seed as u64 + tx + tz) ^ 987234911) as i64 ^ MULTIPLIER) & MASK) * MULTIPLIER + 11)
        as u64
        & MASK as u64)
        >> 17)
        % 10
        == 0
}
