/*
Copyright (c) 2011-2014 Timur Gafarov 

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module dlib.math.vector;

private
{
    import std.conv;
    import std.math;
    import std.random;
    import std.range;
    import std.format;
    import std.traits;
    import dlib.core.tuple;

    import dlib.math.utils;
    import dlib.math.matrix;
}

public:

struct Vector(T, int size)
{
    public:

   /* 
    * Vector constructor
    * Supports initializing from vector of arbitrary length
    */
    this (int size2)(Vector!(T, size2) v)
    {           
        if (v.arrayof.length >= size)
            foreach(i; 0..size)
                arrayof[i] = v.arrayof[i];       
        else
            foreach(i; 0..v.arrayof.length)
                arrayof[i] = v.arrayof[i];
    }

   /* 
    * Array constructor
    */
    this (A)(A components) if (isArray!A && !isSomeString!A)
    {        
        if (components.length >= size)
            foreach(i; 0..size)
                arrayof[i] = components[i];       
        else
            foreach(i; 0..components.length)
                arrayof[i] = components[i];
    }

   /* 
    * Tuple constructor
    */
    this (F...)(F components)
    {
        foreach(i, v; components)
            static if (i < size)
                arrayof[i] = v;
    }

   /* 
    * String constructor
    */
    this (S)(S str) if (isSomeString!S)
    {
        arrayof = parse!(T[size])(str);
    }

   /* 
    * Vector!(T,size) = Vector!(T,size2)
    */
    void opAssign(int size2)(Vector!(T,size2) v)
    {           
        if (v.arrayof.length >= size)
            foreach(i; 0..size)
                arrayof[i] = v.arrayof[i];       
        else
            foreach(i; 0..v.arrayof.length)
                arrayof[i] = v.arrayof[i];
    }

   /* 
    * -Vector!(T,size)
    */
    Vector!(T,size) opUnary(string s) () const if (s == "-")
    body
    {
        Vector!(T,size) res;

        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = -arrayof[i]; 
        return res;
    }

   /* 
    * +Vector!(T,size)
    */
    Vector!(T,size) opUnary(string s) () const if (s == "+")
    body
    {
        return Vector!(T,size)(this);
    }

   /*
    * Vector!(T,size) + Vector!(T,size)
    */
    Vector!(T,size) opAdd (Vector!(T,size) v) const
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] + v.arrayof[i]); 
        return res;
    }

   /*
    * Vector!(T,size) - Vector!(T,size)
    */
    Vector!(T,size) opSub (Vector!(T,size) v) const
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] - v.arrayof[i]); 
        return res;
    }

   /*
    * Vector!(T,size) * Vector!(T,size)
    */
    Vector!(T,size) opBinary(string op) (Vector!(T,size) v) const if (op == "*")
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] * v.arrayof[i]); 
        return res;
    }

   /*
    * Vector!(T,size) / Vector!(T,size)
    */
    Vector!(T,size) opDiv (Vector!(T,size) v) const
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] / v.arrayof[i]); 
        return res;
    }

   /*
    * Vector!(T,size) + T
    */
    Vector!(T,size) opAdd (T t) const
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] + t);
        return res;
    }

   /*
    * Vector!(T,size) - T
    */
    Vector!(T,size) opSub (T t) const
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] - t);
        return res;
    }

   /*
    * Vector!(T,size) * T
    */
    Vector!(T,size) opBinary(string op) (T t) const if (op == "*")
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] * t);
        return res;
    }

   /*
    * T * Vector!(T,size)
    */
    Vector!(T,size) opBinaryRight(string op) (T t) const if (op == "*" && isNumeric!T)
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] * t);
        return res;
    }

   /*
    * Vector!(T,size) / T
    */
    Vector!(T,size) opDiv (T t) const
    body
    {
        Vector!(T,size) res;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            res.arrayof[i] = cast(T)(arrayof[i] / t);
        return res;
    }

   /*
    * Vector!(T,size) += Vector!(T,size)
    */
    Vector!(T,size) opAddAssign (Vector!(T,size) v)
    body
    {
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] += v.arrayof[i];
        return this;
    }

   /*
    * Vector!(T,size) -= Vector!(T,size)
    */
    Vector!(T,size) opSubAssign (Vector!(T,size) v)
    body
    {
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] -= v.arrayof[i];
        return this;
    }

   /*
    * Vector!(T,size) *= Vector!(T,size)
    */
    Vector!(T,size) opMulAssign (Vector!(T,size) v)
    body
    {
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] *= v.arrayof[i];
        return this;
    }

   /*
    * Vector!(T,size) /= Vector!(T,size)
    */
    Vector!(T,size) opDivAssign (Vector!(T,size) v)
    body
    {
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] /= v.arrayof[i];
        return this;
    }

   /*
    * Vector!(T,size) += T
    */
    Vector!(T,size) opAddAssign (T t)
    body
    {
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] += t;
        return this;
    }

   /*
    * Vector!(T,size) -= T
    */
    Vector!(T,size) opSubAssign (T t)
    body
    {
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] -= t;
        return this;
    }

   /*
    * Vector!(T,size) *= T
    */
    Vector!(T,size) opMulAssign (T t)
    body
    {
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] *= t;
        return this;
    }

   /*
    * Vector!(T,size) /= T
    */
    Vector!(T,size) opDivAssign (T t)
    body
    {
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] /= t;
        return this;
    }

   /*
    * T = Vector!(T,size)[index]
    */
    auto ref T opIndex (this X)(size_t index)
    in
    {
        assert ((0 <= index) && (index < size),
            "Vector!(T,size).opIndex(int index): array index out of bounds");  
    }
    body
    {
        return arrayof[index]; 
    }

   /*
    * Vector!(T,size)[index] = T
    */
    void opIndexAssign (T n, size_t index)
    in
    {
        assert ((0 <= index) && (index < size),
            "Vector!(T,size).opIndexAssign(int index): array index out of bounds");  
    }
    body
    {
        arrayof[index] = n;
    }

   /*
    * T[] = Vector!(T,size)[index1..index2]
    */
    auto opSlice (this X)(size_t index1, size_t index2)
    in
    {
        assert ((0 <= index1) || (index1 < 3) || (0 <= index2) || (index2 < 3) || (index1 < index2), 
            "Vector!(T,size).opSlice(int index1, int index2): array index out of bounds");  
    }
    body
    {
        return arrayof[index1..index2];
    }

   /*
    * Vector!(T,size)[index1..index2] = T
    */
    T opSliceAssign (T t, size_t index1, size_t index2)
    in
    {
        assert ((0 <= index1) || (index1 < 3) || (0 <= index2) || (index2 < 3) || (index1 < index2), 
            "Vector!(T,size).opSliceAssign(T t, int index1, int index2): array index out of bounds");  
    }
    body
    {
        arrayof[index1..index2] = t;
        return t;
    }

   /*
    * T = Vector!(T,size)[]
    */
    auto opSlice (this X)()
    body
    {
        return arrayof[];
    }

   /*
    * Vector!(T,size)[] = T
    */
    T opSliceAssign (T t)
    body
    {
        //arrayof[] = t;
        //foreach(i; 0..size)
        foreach(i; RangeTuple!(0, size))
            arrayof[i] = t;
        return t;
    }

    static if (isNumeric!(T))
    {
       /*
        * Get vector length squared
        */
        @property T lengthsqr() const
        body
        {
            T res = 0;
            foreach (component; arrayof) 
                res += component * component;
            return res;
        }

       /*
        * Get vector length
        */
        @property T length() const
        body
        {
            static if (isFloatingPoint!T)
            {
                T t = 0;
                foreach (component; arrayof) 
                    t += component * component;
                return sqrt(t);
            }
            else
            {
                T t = 0;
                foreach (component; arrayof) 
                    t += component * component;
                return cast(T)sqrt(cast(float)t);
            }
        }

       /*
        * Set vector length to 1
        */
        void normalize()
        body
        {
            static if (isFloatingPoint!T)
            {
                T lensqr = lengthsqr();
                if (lensqr > 0)
                {
                    T coef = 1.0 / sqrt(lensqr);
                    foreach (ref component; arrayof) 
                        component *= coef;
                }
            }
            else
            {
                T lensqr = lengthsqr();
                if (lensqr > 0)
                {
                    float coef = 1.0 / sqrt(cast(float)lensqr);
                    foreach (ref component; arrayof) 
                        component *= coef;
                }
            }
        }

       /*
        * Return normalized copy
        */
        @property Vector!(T,size) normalized() const
        body
        {
            Vector!(T,size) res = this;
            res.normalize();
            return res;
        }

       /*
        * Return true if all components are zero
        */
        @property bool isZero() const
        body
        {
            return (arrayof[] == [0]);
        }

       /*
        * Clamp components to min/max value
        */
        void clamp(T minv, T maxv)
        {
            foreach (ref v; arrayof) 
                v = .clamp(v, minv, maxv);
        }
    }

   /*
    * Convert to string
    */
    @property string toString() const
    body
    {
        auto writer = appender!string();
        formattedWrite(writer, "%s", arrayof);
        return writer.data;
    }

   /*
    * Swizzling
    */
    template opDispatch(string s) if (valid(s))
    {
        static if (s.length == 1)
        {
            enum i = ["x":0, "y":1, "z":2, "w":3,
                      "r":0, "g":1, "b":2, "a":3,
                      "s":0, "t":1, "p":2, "q":3][s];

            @property auto ref opDispatch(this X)()
            {
                return arrayof[i];
            }

            @property auto ref opDispatch(this X, V)(auto ref V v)
            {
                return arrayof[i] = v;
            }
        }
        else static if (s.length <= 4)
        { 
            @property auto ref opDispatch(this X)()
            {
                auto extend(string s) 
                {
                    while (s.length < 4) 
                        s ~= s[$-1];
                    return s;
                }

                enum p = extend(s);
                enum i = (char c) => ['x':0, 'y':1, 'z':2, 'w':3,
                                      'r':0, 'g':1, 'b':2, 'a':3,
                                      's':0, 't':1, 'p':2, 'q':3][c];
                enum i0 = i(p[0]), 
                     i1 = i(p[1]), 
                     i2 = i(p[2]), 
                     i3 = i(p[3]);

                static if (s.length == 4)
                    return Vector!(T,4)(arrayof[i0], arrayof[i1], arrayof[i2], arrayof[i3]);
                else static if (s.length == 3)
                    return Vector!(T,3)(arrayof[i0], arrayof[i1], arrayof[i2]);
                else static if (s.length == 2)
                    return Vector!(T,2)(arrayof[i0], arrayof[i1]);
            }
        }
    }

    private static bool valid(string s) 
    {
        foreach(c; s)
        {
            switch(c)
            {
                case 'w', 'a', 'q': 
                    if (size < 4) return false;
                    else break;
                case 'z', 'b', 'p': 
                    if (size < 3) return false;
                    else break;
                case 'y', 'g', 't': 
                    if (size < 2) return false;
                    else break;
                case 'x', 'r', 's': 
                    if (size < 1) return false;
                    else break;
                default:
                    return false;
            }
        }
        return true;
    }

   /*
    * Vector components
    */
    T[size] arrayof;
}

/*
 * Dot product
 */
T dot(T, int size) (Vector!(T,size) a, Vector!(T,size) b)
body
{
    static if (size == 1)
    {
        return a.x * b.x;
    }
    else
    static if (size == 2)
    {
        return ((a.x * b.x) + (a.y * b.y));
    }
    else
    static if (size == 3)
    {
        return ((a.x * b.x) + (a.y * b.y) + (a.z * b.z));
    }
    else
    {
        T d = 0;
        //foreach (i; 0..size)
        foreach(i; RangeTuple!(0, size))
            d += a[i] * b[i];
        return d;
    }
}

/*
 * Cross product
 */
Vector!(T,size) cross(T, int size) (Vector!(T,size) a, Vector!(T,size) b) if (size == 3)
body
{
    return Vector!(T,size) 
    (
        (a.y * b.z) - (a.z * b.y),
        (a.z * b.x) - (a.x * b.z),
        (a.x * b.y) - (a.y * b.x)
    );
}

Vector!(T,size) cross(T, int size) (Vector!(T,size) a, Vector!(T,size) b, Vector!(T,size) c) if (size == 4)
body
{
    return Vector!(T,size) 
    (
        (a.y * b.z * c.w) - (a.y * b.w * c.z) 
      + (a.z * b.w * c.y) - (a.z * b.y * c.w) 
      + (a.w * b.y * c.z) - (a.w * b.z * c.y),
      
        (a.z * b.w * c.x) - (a.z * b.x * c.w) 
      + (a.w * b.x * c.z) - (a.w * b.z * c.x) 
      + (a.x * b.z * c.w) - (a.x * b.w * c.z),
      
        (a.w * b.x * c.y) - (a.w * b.y * c.x) 
      + (a.x * b.y * c.w) - (a.x * b.w * c.y) 
      + (a.y * b.w * c.x) - (a.y * b.x * c.w),
      
        (a.x * b.y * c.z) - (a.x * b.z * c.y) 
      + (a.y * b.z * c.x) - (a.y * b.x * c.z) 
      + (a.z * b.x * c.y) - (a.z * b.y * c.x)
    );
}

/*
 * Tensor product
 */
Matrix!(T,N) tensorProduct(T, size_t N) (Vector!(T,N) u, Vector!(T,N) v)
body
{
    Matrix!(T,N) res;
    foreach(i; 0..N)
    foreach(j; 0..N)
    {
        res[i, j] = u[i] * v[j];
    }
    return res;
}

alias tensorProduct outerProduct;

/*
 * Compute normal of a plane from three points
 */
Vector!(T,3) normal(T) (Vector!(T,3) p1, Vector!(T,3) p2, Vector!(T,3) p3)
body
{
    Vector!(T,3) vec1 = Vector!(T,3)(p1 - p2);
    Vector!(T,3) vec2 = Vector!(T,3)(p1 - p3);
    
    Vector!(T,3) result = Vector!(T,3)(cross(vec1,vec2));
    result.normalize();

    return result;
}

void rotateAroundAxis(T) (ref Vector!(T,3) V, Vector!(T,3) P, Vector!(T,3) D, T angle)
{
    T axx,axy,axz,ax1;
    T ayx,ayy,ayz,ay1;
    T azx,azy,azz,az1;

    T u,v,w;
    T u2,v2,w2;    T a,b,c;
    T sa,ca;

    sa = sin(angle);
    ca = cos(angle);

    u = D.x;    v = D.y;
    w = D.z;
    
    u2 = u * u;
    v2 = v * v;    w2 = w * w;

    a = P.x;
    b = P.y;
    c = P.z;

    axx = u2+(v2+w2)*ca;   
    axy = u*v*(1-ca)-w*sa; 
    axz = u*w*(1-ca)+v*sa; 
    ax1 = a*(v2+w2)-u*(b*v+c*w)+(u*(b*v+c*w)-a*(v2+w2))*ca+(b*w-c*v)*sa;
    
    ayx = u*v*(1-ca)+w*sa; 
    ayy = v2+(u2+w2)*ca;   
    ayz = v*w*(1-ca)-u*sa; 
    ay1 = b*(u2+w2)-v*(a*u+c*w)+(v*(a*u+c*w)-b*(u2+w2))*ca+(c*u-a*w)*sa;
    
    azx = u*w*(1-ca)-v*sa; 
    azy = v*w*(1-ca)+u*sa; 
    azz = w2+(u2+v2)*ca;   
    
    az1 = c*(u2+v2)-w*(a*u+b*v)+(w*(a*u+b*v)-c*(u2+v2))*ca+(a*v-b*u)*sa;

    Vector!(T,3) W;
    W.x = axx * V.x + axy * V.y + axz * V.z + ax1;
    W.y = ayx * V.x + ayy * V.y + ayz * V.z + ay1;
    W.z = azx * V.x + azy * V.y + azz * V.z + az1;

    V = W;
}

/* 
 * Compute distance between two points
 */
T distance(T) (Vector!(T,3) a, Vector!(T,3) b)
body
{
    T dx = a.x - b.x;
    T dy = a.y - b.y;
    T dz = a.z - b.z;
    return sqrt((dx * dx) + (dy * dy) + (dz * dz));
}

T distancesqr(T) (Vector!(T,3) a, Vector!(T,3) b)
body
{
    T dx = a.x - b.x;
    T dy = a.y - b.y;
    T dz = a.z - b.z;
    return ((dx * dx) + (dy * dy) + (dz * dz));
}

/*
 * Random unit length vectors
 */
Vector!(T,2) randomUnitVector2(T)()
{
    float azimuth = uniform(0.0, 1.0) * 2 * PI;
    return Vector!(T,2)(cos(azimuth), sin(azimuth));
}

Vector!(T,3) randomUnitVector3(T)()
{
    float z = (2 * uniform(0.0, 1.0)) - 1;
    Vector!(T,2) planar = randomUnitVector2!(T)() * sqrt(1 - z * z);
    return Vector!(T,3)(planar.x, planar.y, z);
}

/*
 * Interpolation
 */
Vector!(T,3) slerp(T) (Vector!(T,3) a, Vector!(T,3) b, T t)
{
    T dp = dot(a, b);     
    dp = clamp(dp, -1.0, 1.0);
    T theta = acos(dp) * t;
    Vector!(T,3) relativeVec = b - a * dp;
    relativeVec.normalize();
    return ((a * cos(theta)) + (relativeVec * sin(theta)));
}

/*
 * Gradually decrease vector to zero length
 */
Vector!(T,3) vectorDecreaseToZero(T) (Vector!(T,3) vector, T step)
{
    foreach (ref component; vector.arrayof)
    {
        if (component > 0.0)
            component -= step;
        if (component < 0.0)
            component += step;
    }
    return vector;
}

/*
 * Almost zero
 */
bool isAlmostZero(Vector3f v)
{
    return (isConsiderZero(v.x) &&
            isConsiderZero(v.y) &&
            isConsiderZero(v.z));
}

/*
 * Predefined vector types
 */
alias Vector!(int, 2) Vector2i;
alias Vector!(uint, 2) Vector2u;
alias Vector!(float, 2) Vector2f;
alias Vector!(double, 2) Vector2d;

alias Vector!(int, 3) Vector3i;
alias Vector!(uint, 3) Vector3u;
alias Vector!(float, 3) Vector3f;
alias Vector!(double, 3) Vector3d;

alias Vector!(int, 4) Vector4i;
alias Vector!(uint, 4) Vector4u;
alias Vector!(float, 4) Vector4f;
alias Vector!(double, 4) Vector4d;

/*
 * Short aliases
 */
alias Vector2i ivec2;
alias Vector2u uvec2;
alias Vector2f vec2;
alias Vector2d dvec2;

alias Vector3i ivec3;
alias Vector3u uvec3;
alias Vector3f vec3;
alias Vector3d dvec3;

alias Vector4i ivec4;
alias Vector4u uvec4;
alias Vector4f vec4;
alias Vector4d dvec4;

/*
 * Axis vectors
 */
static struct AxisVector
{
    Vector3f x = Vector3f(1.0f, 0.0f, 0.0f);
    Vector3f y = Vector3f(0.0f, 1.0f, 0.0f);
    Vector3f z = Vector3f(0.0f, 0.0f, 1.0f);
}

// For some reason, this doesn't work:
/*
enum AxisVector: Vector3f
{
    x = Vector3f(1.0f, 0.0f, 0.0f),
    y = Vector3f(0.0f, 1.0f, 0.0f),
    z = Vector3f(0.0f, 0.0f, 1.0f)
}
*/

/*
 * Vector factory function 
 */
auto vectorf(T...)(T t) if (t.length > 0)
{
    return Vector!(float, t.length)(t);
}

/*
 * L-value pseudovector for assignment purposes.
 *
 * Usage example:
 *
 *  float a, b, c
 *  lvector(a, b, c) = Vector3f(10, 4, 2);
 */
auto lvector(T...)(ref T x)
{
    struct Result(T, uint size)
    {
        T*[size] arrayof;

        void opAssign(int size2)(Vector!(T,size2) v)
        {
            if (v.arrayof.length >= size)
                foreach(i; 0..size)
                    *arrayof[i] = v.arrayof[i];       
            else
                foreach(i; 0..v.arrayof.length)
                    *arrayof[i] = v.arrayof[i];
        }
    }

    auto res = Result!(typeof(x[0]), x.length)();

    foreach(i, ref v; x)
        res.arrayof[i] = &v;

    return res;
}

unittest
{
    const vec3 a = vec3(10.5f, 20.0f, 33.12345f);
    const vec3 b = -a;
    const vec3 c = +a - b;
    const vec3 d = a * b / c;

    assert(isAlmostZero(to!vec3(c.toString()) - c));

    ivec2 ab = ivec2(5, 15);
    ab += ivec2(20, 30);
    ab *= 3;

    assert(ab[0] == 75 && ab[1] == 135);

    c.length();
    c.lengthsqr();
    distance(a, b);

    auto xy = a[0..1];
    auto n = a[];
}
