/// gauss(mean,deviation)
//
//  Returns a pseudo-random number with an exact Gaussian distribution.
//
//      mean        mean value of the distribution, real
//      deviation   standard deviation of distribution, real
//
/// GMLscripts.com/license
/// r2 should be sqrt(how much to deviate)
function random_gauss(mean_, deviation_) {
    var x1, x2, w, r1 = mean_, r2 = deviation_;
 
    do {
        x1 = random(2) - 1;
        x2 = random(2) - 1;
        w = x1*x1 + x2*x2;
    } until (0 < w && w < 1);
 
    w = sqrt(-2 * ln(w)/w);
    return r1 + r2 * x1 * w;
}