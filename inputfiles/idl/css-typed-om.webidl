[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSStyleValue {
    stringifier;
    [Exposed=Window] static CSSStyleValue parse(USVString property, USVString cssText);
    [Exposed=Window] static sequence<CSSStyleValue> parseAll(USVString property, USVString cssText);
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface StylePropertyMapReadOnly {
    iterable<USVString, sequence<CSSStyleValue>>;
    any get(USVString property);
    /* 'any' means (undefined or CSSStyleValue) here,
       see https://github.com/heycam/webidl/issues/60 */
    sequence<CSSStyleValue> getAll(USVString property);
    boolean has(USVString property);
    readonly attribute unsigned long size;
};

[Exposed=Window]
interface StylePropertyMap : StylePropertyMapReadOnly {
    undefined set(USVString property, (CSSStyleValue or USVString)... values);
    undefined append(USVString property, (CSSStyleValue or USVString)... values);
    undefined delete(USVString property);
    undefined clear();
};

partial interface Element {
    [SameObject] StylePropertyMapReadOnly computedStyleMap();
};

partial interface CSSStyleRule {
    [SameObject] readonly attribute StylePropertyMap styleMap;
};

partial interface mixin ElementCSSInlineStyle {
    [SameObject] readonly attribute StylePropertyMap attributeStyleMap;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSUnparsedValue : CSSStyleValue {
    constructor(sequence<CSSUnparsedSegment> members);
    iterable<CSSUnparsedSegment>;
    readonly attribute unsigned long length;
    getter CSSUnparsedSegment (unsigned long index);
    setter CSSUnparsedSegment (unsigned long index, CSSUnparsedSegment val);
};

typedef (USVString or CSSVariableReferenceValue) CSSUnparsedSegment;

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSVariableReferenceValue {
    constructor(USVString variable, optional CSSUnparsedValue? fallback = null);
    attribute USVString variable;
    readonly attribute CSSUnparsedValue? fallback;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSKeywordValue : CSSStyleValue {
    constructor(USVString value);
    attribute USVString value;
};

typedef (DOMString or CSSKeywordValue) CSSKeywordish;

typedef (double or CSSNumericValue) CSSNumberish;

enum CSSNumericBaseType {
    "length",
    "angle",
    "time",
    "frequency",
    "resolution",
    "flex",
    "percent",
};

dictionary CSSNumericType {
    long length;
    long angle;
    long time;
    long frequency;
    long resolution;
    long flex;
    long percent;
    CSSNumericBaseType percentHint;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSNumericValue : CSSStyleValue {
    CSSNumericValue add(CSSNumberish... values);
    CSSNumericValue sub(CSSNumberish... values);
    CSSNumericValue mul(CSSNumberish... values);
    CSSNumericValue div(CSSNumberish... values);
    CSSNumericValue min(CSSNumberish... values);
    CSSNumericValue max(CSSNumberish... values);

    boolean equals(CSSNumberish... value);

    CSSUnitValue to(USVString unit);
    CSSMathSum toSum(USVString... units);
    CSSNumericType type();

    [Exposed=Window] static CSSNumericValue parse(USVString cssText);
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSUnitValue : CSSNumericValue {
    constructor(double value, USVString unit);
    attribute double value;
    readonly attribute USVString unit;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMathValue : CSSNumericValue {
    readonly attribute CSSMathOperator operator;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMathSum : CSSMathValue {
    constructor(CSSNumberish... args);
    readonly attribute CSSNumericArray values;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMathProduct : CSSMathValue {
    constructor(CSSNumberish... args);
    readonly attribute CSSNumericArray values;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMathNegate : CSSMathValue {
    constructor(CSSNumberish arg);
    readonly attribute CSSNumericValue value;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMathInvert : CSSMathValue {
    constructor(CSSNumberish arg);
    readonly attribute CSSNumericValue value;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMathMin : CSSMathValue {
    constructor(CSSNumberish... args);
    readonly attribute CSSNumericArray values;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMathMax : CSSMathValue {
    constructor(CSSNumberish... args);
    readonly attribute CSSNumericArray values;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMathClamp : CSSMathValue {
    constructor(CSSNumberish min, CSSNumberish val, CSSNumberish max);
    readonly attribute CSSNumericValue min;
    readonly attribute CSSNumericValue val;
    readonly attribute CSSNumericValue max;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSNumericArray {
    iterable<CSSNumericValue>;
    readonly attribute unsigned long length;
    getter CSSNumericValue (unsigned long index);
};

enum CSSMathOperator {
    "sum",
    "product",
    "negate",
    "invert",
    "min",
    "max",
    "clamp",
};

partial namespace CSS {
    CSSUnitValue number(double value);
    CSSUnitValue percent(double value);

    // <length>
    CSSUnitValue em(double value);
    CSSUnitValue ex(double value);
    CSSUnitValue ch(double value);
    CSSUnitValue ic(double value);
    CSSUnitValue rem(double value);
    CSSUnitValue lh(double value);
    CSSUnitValue rlh(double value);
    CSSUnitValue vw(double value);
    CSSUnitValue vh(double value);
    CSSUnitValue vi(double value);
    CSSUnitValue vb(double value);
    CSSUnitValue vmin(double value);
    CSSUnitValue vmax(double value);
    CSSUnitValue cm(double value);
    CSSUnitValue mm(double value);
    CSSUnitValue Q(double value);
    CSSUnitValue in(double value);
    CSSUnitValue pt(double value);
    CSSUnitValue pc(double value);
    CSSUnitValue px(double value);

    // <angle>
    CSSUnitValue deg(double value);
    CSSUnitValue grad(double value);
    CSSUnitValue rad(double value);
    CSSUnitValue turn(double value);

    // <time>
    CSSUnitValue s(double value);
    CSSUnitValue ms(double value);

    // <frequency>
    CSSUnitValue Hz(double value);
    CSSUnitValue kHz(double value);

    // <resolution>
    CSSUnitValue dpi(double value);
    CSSUnitValue dpcm(double value);
    CSSUnitValue dppx(double value);

    // <flex>
    CSSUnitValue fr(double value);
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSTransformValue : CSSStyleValue {
    constructor(sequence<CSSTransformComponent> transforms);
    iterable<CSSTransformComponent>;
    readonly attribute unsigned long length;
    getter CSSTransformComponent (unsigned long index);
    setter CSSTransformComponent (unsigned long index, CSSTransformComponent val);

    readonly attribute boolean is2D;
    DOMMatrix toMatrix();
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSTransformComponent {
    stringifier;
    attribute boolean is2D;
    DOMMatrix toMatrix();
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSTranslate : CSSTransformComponent {
    constructor(CSSNumericValue x, CSSNumericValue y, optional CSSNumericValue z);
    attribute CSSNumericValue x;
    attribute CSSNumericValue y;
    attribute CSSNumericValue z;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSRotate : CSSTransformComponent {
    constructor(CSSNumericValue angle);
    constructor(CSSNumberish x, CSSNumberish y, CSSNumberish z, CSSNumericValue angle);
    attribute CSSNumberish x;
    attribute CSSNumberish y;
    attribute CSSNumberish z;
    attribute CSSNumericValue angle;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSScale : CSSTransformComponent {
    constructor(CSSNumberish x, CSSNumberish y, optional CSSNumberish z);
    attribute CSSNumberish x;
    attribute CSSNumberish y;
    attribute CSSNumberish z;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSSkew : CSSTransformComponent {
    constructor(CSSNumericValue ax, CSSNumericValue ay);
    attribute CSSNumericValue ax;
    attribute CSSNumericValue ay;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSSkewX : CSSTransformComponent {
    constructor(CSSNumericValue ax);
    attribute CSSNumericValue ax;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSSkewY : CSSTransformComponent {
    constructor(CSSNumericValue ay);
    attribute CSSNumericValue ay;
};

/* Note that skew(x,y) is *not* the same as skewX(x) skewY(y),
   thus the separate interfaces for all three. */

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSPerspective : CSSTransformComponent {
    constructor(CSSNumericValue length);
    attribute CSSNumericValue length;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSMatrixComponent : CSSTransformComponent {
    constructor(DOMMatrixReadOnly matrix, optional CSSMatrixComponentOptions options = {});
    attribute DOMMatrix matrix;
};

dictionary CSSMatrixComponentOptions {
    boolean is2D;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSImageValue : CSSStyleValue {
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSColorValue : CSSStyleValue {
    CSSRGB toRGB();
    CSSHSL toHSL();
    CSSHWB toHWB();
    CSSGray toGray();
    CSSLCH toLCH();
    CSSLab toLab();
    CSSColor toColor(CSSKeywordish colorspace);

    [Exposed=Window] static CSSColorValue parse(USVString cssText);
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSRGB : CSSColorValue {
    constructor(CSSNumberish r, CSSNumberish g, CSSNumberish b, optional CSSNumberish alpha = 1);
    attribute CSSNumberish r;
    attribute CSSNumberish g;
    attribute CSSNumberish b;
    attribute CSSNumberish alpha;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSHSL : CSSColorValue {
    constructor(CSSNumericValue h, CSSNumberish s, CSSNumberish l, optional CSSNumberish alpha = 1);
    attribute CSSNumericValue h;
    attribute CSSNumberish s;
    attribute CSSNumberish l;
    attribute CSSNumberish alpha;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSHWB : CSSColorValue {
    constructor(CSSNumericValue h, CSSNumberish w, CSSNumberish b, optional CSSNumberish alpha = 1);
    attribute CSSNumericValue h;
    attribute CSSNumberish w;
    attribute CSSNumberish b;
    attribute CSSNumberish alpha;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSGray : CSSColorValue {
    constructor(CSSNumberish gray, optional CSSNumberish alpha = 1);
    attribute CSSNumberish gray;
    attribute CSSNumberish alpha;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSLCH : CSSColorValue {
    constructor(CSSNumberish l, CSSNumberish c, CSSNumericValue h, optional CSSNumberish alpha = 1);
    attribute CSSNumberish l;
    attribute CSSNumberish c;
    attribute CSSNumericValue h;
    attribute CSSNumberish alpha;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSLab : CSSColorValue {
    constructor(CSSNumberish l, CSSNumberish a, CSSNumberish b, optional CSSNumberish alpha = 1);
    attribute CSSNumberish l;
    attribute CSSNumberish a;
    attribute CSSNumberish b;
    attribute CSSNumberish alpha;
};

[Exposed=(Window, Worker, PaintWorklet, LayoutWorklet)]
interface CSSColor : CSSColorValue {
    constructor(sequence<(DOMString or CSSNumberish)> variant);
    /* CSSColor(["foo", 0, 1, .5], ["bar", "yellow"], 1, fallbackColor) */
    /* or just make the alpha and fallback successive optional args? */
};
