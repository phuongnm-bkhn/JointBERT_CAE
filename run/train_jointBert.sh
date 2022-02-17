ME_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
ME_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
ME="$ME_PATH/$ME_NAME"
DATA_ID=atis
git diff > $ME_PATH/code.diff

cd libs/JointBERT
EP=20
SLOT_LOSS_COEF=0.5
WDECAY=0.0
MODEL_DIR="${DATA_ID}_models/ep$EP-Wloss"
mkdir $MODEL_DIR
cp $ME $MODEL_DIR
mv $ME_PATH/code.diff $MODEL_DIR

python3 main.py --task ${DATA_ID} \
                  --model_type bert \
                  --model_dir $MODEL_DIR \
                  --do_train --do_eval --weight_decay $WDECAY --slot_loss_coef $SLOT_LOSS_COEF \
                  --num_train_epochs $EP |& tee $MODEL_DIR/train.log