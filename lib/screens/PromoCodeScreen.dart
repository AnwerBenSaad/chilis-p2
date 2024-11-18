import 'package:flutter/material.dart';
import '../models/codepromo.dart';
import '../services/CodePromoServices.dart';

class PromoCodeScreen extends StatefulWidget {
  @override
  _PromoCodeScreenState createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  final CodePromoService _codePromoService = CodePromoService();
  List<CodePromo> _promoCodes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPromoCodes();
  }

  Future<void> _fetchPromoCodes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final promoCodes = await _codePromoService.fetchPromoCodes();
      setState(() {
        _promoCodes = promoCodes;
      });
    } catch (e) {
      print('Error fetching promo codes: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addPromoCode() async {
    final codeController = TextEditingController();
    final reductionController = TextEditingController();
    final expirationController = TextEditingController();
    DateTime selectedDate = DateTime.now(); // Date sélectionnée initialement
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Promo Code'),
              content: Column(
                children: [
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(labelText: 'Code'),
                  ),
                  TextField(
                    controller: reductionController,
                    decoration: InputDecoration(labelText: 'Reduction (%)'),
                    keyboardType: TextInputType.number,
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                          expirationController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Formater la date
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: expirationController,
                        decoration: InputDecoration(labelText: 'Expiration Date'),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    if (double.parse(reductionController.text) > 100) {
                      // Afficher un message d'avertissement si réduction > 100
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Warning'),
                          content: Text('Discount cannot exceed 100%.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else if (selectedDate.isBefore(DateTime.now())) {
                      // Avertissement si la date d'expiration est avant aujourd'hui
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Warning'),
                          content: Text('Expiration date cannot be in the past.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      setState(() => isLoading = true);
                      final newPromoCode = CodePromo(
                        id: 0,
                        code: codeController.text,
                        reduction: double.parse(reductionController.text),
                        dateExpiration: selectedDate,
                      );
                      await _codePromoService.addPromoCode(newPromoCode);
                      setState(() => isLoading = false);
                      Navigator.pop(context);
                      _fetchPromoCodes();
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Méthode pour afficher la boîte de confirmation avant la suppression
  Future<bool> _showDeleteConfirmationDialog(int id) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Promo Code'),
          content: Text('Are you sure you want to delete this promo code?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    return confirmDelete ?? false; // If null, return false by default
  }


  // Fonction pour supprimer le code promo
  Future<void> _deletePromoCode(int id) async {
    try {
      setState(() => _isLoading = true);
      await _codePromoService.deletePromoCode(id);
      _fetchPromoCodes(); // Rafraîchir la liste après suppression
    } catch (e) {
      print('Error deleting promo code: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promo Codes'),
        backgroundColor: Colors.red,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _promoCodes.isEmpty
          ? Center(child: Text('No promo codes available'))
          : ListView.builder(
        itemCount: _promoCodes.length,
        itemBuilder: (context, index) {
          final promoCode = _promoCodes[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(promoCode.code),
              subtitle: Text('Discount: ${promoCode.reduction}%'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Expires on: ${promoCode.dateExpiration.toLocal()}'),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool confirm = await _showDeleteConfirmationDialog(promoCode.id);
                      if (confirm) {
                        await _deletePromoCode(promoCode.id);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPromoCode,
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }
}
