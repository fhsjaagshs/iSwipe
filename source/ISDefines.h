#import <Foundation/Foundation.h>

// Algo defines
#define BASE 360
#define BAD -1
#define BONUS -5

// Geometry defines

#define PI 3.14159265358
#define toDegrees(x) (x * 180 / PI)

static inline double dist(double dx1, double dy1){
    return sqrt(dx1*dx1 + dy1*dy1);
}

static inline double dot(double dx1, double dy1, double dx2, double dy2){
    return dx1 * dx2 + dy1 * dy2;
}

static inline double cross(double dx1, double dy1, double dx2, double dy2){
    return dx1 * dy2 - dx2 * dy1;
}

static inline double vecAng(double dx1, double dy1, double dx2, double dy2){
    double dt = dot(dx1, dy1, dx2, dy2);
    dt /= dist(dx1, dy1) * dist(dx2, dy2);
    if( dt > 1 ) dt = 1;
    else if( dt < -1) dt = -1;
    return toDegrees(acos(dt));
}

static inline double ptDist(double x1, double y1, double x2, double y2, double px, double py){
    
    double dx1 = x2-x1; //vec p1 -> p2
    double dy1 = y2-y1;
    double dx2 = px-x1; //p1 -> pt
    double dy2 = py-y1;
    double dx3 = px-x2; //p2 -> pt
    double dy3 = py-y2; 
    double dx4 = x1-x2; //p2 -> p1
    double dy4 = y1-y2;
    
    
    /* p1->p2 X p1->pt
     
           pt
           |
           |
     p1 ------ p2
     
     */
    double d1 =  cross(dx1, dy1, dx2, dy2) / dist(dx1, dy1);
    
    /*  p2->pt * p1->p2
     
                   pt
                  /
                 /
     p1 ------ p2 
     
     */
    if(dot(dx3, dy3, dx1, dy1) > 0) return dist(dx3, dy3);
    
    /*  p1->pt * p2->p1
     
     pt
      \
       \
        p1 ------ p2 
     
     */
    if(dot(dx2, dy2, dx4, dy4) > 0)return dist(dx2, dy2);
    
    return abs(d1);
}
