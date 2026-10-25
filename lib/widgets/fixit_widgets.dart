import "package:flutter/material.dart";

// import "../models/hazard_report.dart";

const blue = Color(0xFF0D57D5);
const canvas = Color(0xFFF8FAFC);
const potholePhoto =
    "https://images.unsplash.com/photo-1779179015285-120aaa822b1b?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=80&w=700";
const drainPhoto =
    "https://images.unsplash.com/photo-1789018944661-3592583cee58?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=80&w=700";

//temperory drawing the map!
class HazardMap extends StatelessWidget {
  const HazardMap({required this.height, this.expanded = false, super.key});
  final double height;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE4EDE8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD9E3DE)),
      ),
      child: CustomPaint(
        painter: MapPainter(),
        child: Stack(
          children: [
            const Positioned(left: 80, top: 75, child: MapPin(color: Color(0xFFF59E0B), label: "3")),
            Positioned(right: 62, top: expanded ? 170 : 65, child: const MapPin(color: Color(0xFFEF4444), label: "5")),
            Positioned(left: 180, bottom: expanded ? 110 : 32, child: const MapPin(color: blue, icon: Icons.location_on)),
            if (expanded) const Positioned(left: 48, bottom: 115, child: MapPin(color: Color(0xFFF59E0B), label: "2")),
          ],
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 23
      ..strokeCap = StrokeCap.round;
    final edge = Paint()
      ..color = const Color(0xFFD3DEDA)
      ..strokeWidth = 27
      ..strokeCap = StrokeCap.round;
    void draw(Offset a, Offset b) {
      canvas.drawLine(a, b, edge);
      canvas.drawLine(a, b, road);
    }
    draw(Offset(-20, size.height * .7), Offset(size.width + 30, size.height * .38));
    draw(Offset(size.width * .18, -20), Offset(size.width * .67, size.height + 20));
    draw(Offset(size.width * .82, -20), Offset(size.width * .72, size.height + 20));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapPin extends StatelessWidget {
  const MapPin({required this.color, this.label, this.icon, super.key});
  final Color color;
  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: icon != null
          ? Icon(icon, color: Colors.white, size: 17)
          : Text(label!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
    );
  }
}


class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.eyebrow, required this.title, required this.action, super.key});
  final String eyebrow;
  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow.isNotEmpty) Text(eyebrow, style: const TextStyle(color: blue, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2, decoration: TextDecoration.none,)),
              Text(title, style: const TextStyle(color: Colors.black,fontSize:  19, fontWeight: FontWeight.w900, decoration: TextDecoration.none,)),
            ],
          ),
        ),
        TextButton(onPressed: () {}, child: Text(action)),
      ],
    );
  }
}

class ImpactCard extends StatelessWidget {
  const ImpactCard({super.key});
  @override
  Widget build(BuildContext context) => const Card(
        elevation: 0,
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Color(0xFFD1FAE5), child: Icon(Icons.verified_user_outlined, color: Color(0xFF047857))),
          title: Text("Your reports make a difference", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
          subtitle: Text("3 hazards resolved with your help this month.", style: TextStyle(fontSize: 11)),
        ),
      );
}

class MapStats extends StatelessWidget {
  const MapStats({super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfileMetric(value: "12", label: "Active"),
            ProfileMetric(value: "4", label: "Critical"),
            ProfileMetric(value: "8", label: "Assigned"),
          ],
        ),
      );
}

class MetricCard extends StatelessWidget {
  const MetricCard({required this.value, required this.label, required this.color, super.key});
  final String value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))]),
      );
}

class ProfileMetric extends StatelessWidget {
  const ProfileMetric({required this.value, required this.label, super.key});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
        ],
      );
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: blue, borderRadius: BorderRadius.circular(7)),
        child: const Icon(Icons.check, color: Colors.white, size: 14),
      );
}

class NavItem extends StatelessWidget {
  const NavItem({required this.icon, required this.activeIcon, required this.label, required this.selected, required this.onTap, super.key});
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(selected ? activeIcon : icon, color: selected ? blue : const Color(0xFF94A3B8), size: 22),
              const SizedBox(height: 3),
              Text(label, style: TextStyle(color: selected ? blue : const Color(0xFF94A3B8), fontSize: 9, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );
}

// final sampleReports = [
//   HazardReport(
//     id: "FX-2048",
//     title: "Large pothole near bus stop",
//     category: "Road",
//     severity: 4,
//     location: "Lakeview Road · 0.3 km",
//     status: HazardStatus.inProgress,
//     reportedAt: DateTime(2025, 5, 20),
//     imageUrl: potholePhoto,
//   ),
//   HazardReport(
//     id: "FX-2021",
//     title: "Storm drain overflowing",
//     category: "Water",
//     severity: 3,
//     location: "Market Street · 1.1 km",
//     status: HazardStatus.assigned,
//     reportedAt: DateTime(2025, 5, 20),
//     imageUrl: drainPhoto,
//   ),
// ];
