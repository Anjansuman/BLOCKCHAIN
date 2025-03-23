import express from "express";
import { HDNodeWallet, Wallet } from "ethers6";
import { mnemonicToSeed, mnemonicToSeedSync } from "bip39";
import { MNEMONICS } from "./config";
import { client } from "@repo/database/client";

const app = express();
app.use(express.json());

const seed = mnemonicToSeedSync(MNEMONICS);

app.post("/signup", async (req, res) => {
    try {
        const username = req.body.username;
        const password = req.body.password;
    
        const user = await client.user.create({
            data: {
                username,
                password
            }
        });
    
        if(!user) {
            res.json({
                message: "User creation failed!"
            });
            return;
        }
    
        const userId = user.id;
        const hdNode = HDNodeWallet.fromSeed(seed);
        const child = hdNode.derivePath(`m/44'/60'/${userId}/0`);
    
        const address = child.address;
        const privateKey = child.privateKey;
    
        console.log(typeof child.address);
    
        const updateUser = await client.user.update({
            where: {
                id: userId
            }, data: {
                depositAddress: address,
                privateKey: privateKey
            }
        });
    
        if(!updateUser) {
            res.json({
                message: "User update failed!"
            });
            return;
        }
    
        console.log(child); 
        console.log(child.privateKey);
        console.log(user.depositAddress);
        res.json({
            user
        })
    } catch (error) {
        res.json({
            error
        });
        return;
    }
});

app.get("/deposit-address/:userId", async (req, res) => {
    try {
        
        const userId = Number(req.params.userId);

        const user = await client.user.findFirst({
            where: {
                id: userId
            }
        });

        if(!user) {
            res.json({
                message: "User not found!"
            });
            return;
        };

        res.json({
            address: user.depositAddress
        });
        return;

    } catch (error) {
        res.json({
            error 
        });
        return;
    }
});

app.listen(3010);
