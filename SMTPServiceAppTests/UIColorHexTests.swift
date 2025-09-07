import Testing
@testable import SMTPServiceApp
import UIKit

struct UIColorHexTests {

    private func assertColor(
        _ color: UIColor,
        r: CGFloat,
        g: CGFloat,
        b: CGFloat,
        a: CGFloat
    ) {
        var rr: CGFloat = 0, gg: CGFloat = 0, bb: CGFloat = 0, aa: CGFloat = 0
        #expect(color.getRed(&rr, green: &gg, blue: &bb, alpha: &aa))

        #expect(rr == r)
        #expect(gg == g)
        #expect(bb == b)
        #expect(aa == a)
    }

    @Test func testHexRGB() {
        assertColor(UIColor.hex("#FF0000"), r: 1, g: 0, b: 0, a: 1)
    }

    @Test func testHexARGB() {
        assertColor(UIColor.hex("80FF0000"), r: 1, g: 0, b: 0, a: 0.5)
    }

    @Test func testHexShort() {
        assertColor(UIColor.hex("#0F0"), r: 0, g: 1, b: 0, a: 1)
    }

    @Test func testInvalidHex() {
        assertColor(UIColor.hex("ZZZZZZ"), r: 0, g: 0, b: 0, a: 1)
    }
}
